using JuMP
using HiGHS
using TOML

function loadData(path::AbstractString)
    data = TOML.parsefile(path)

    price = Float64.(data["price"]) #cena
    labor_cost = Float64.(data["labor_cost"]) ./ 60 #koszt pracy maszyny na minutę
    material_cost = Float64.(data["material_cost"]) #koszt materiałów
    processing_time = reduce(vcat, [Float64.(row)' for row in data["processing_time"]]) #czas przetwarzania
    max_demand = Float64.(data["max_demand"]) #maksymalny popyt
    availability = Float64.(data["availability"]) #dostępność zasobów

    #Ograniczenia
    m, n = size(processing_time)
    @assert length(price) == n "Liczba cen musi odpowiadać liczbie produktów"
    @assert length(labor_cost) == m "Liczba kosztów pracy musi odpowiadać liczbie zasobów"

    #Marża zysku
    profit = [price[j] - material_cost[j] - sum(labor_cost[i] * processing_time[i, j] for i in 1:m) for j in 1:n]

    return processing_time, availability, max_demand, profit
end    

function solveProductionProblem(processing_time, availability, max_demand, profit)
    I = eachindex(availability)
    J = eachindex(max_demand)

    model = Model(HiGHS.Optimizer) #Tworzy model optymalizacyjny, używając solvera HiGHS
    set_silent(model) #Wyłącza wyjście solvera

    #Zmienne decyzyjne
    @variable(model, x[j in J] >= 0) #ilości produkowane

    #Ograniczenia
    @constraint(model, [i in I], sum(processing_time[i, j] * x[j] for j in J) <= availability[i]) #ograniczenia zasobów
    @constraint(model, [j in J], x[j] <= max_demand[j]) #ograniczenia popytu

    #Funkcja celu
    @objective(model, Max, sum(profit[j] * x[j] for j in J)) #maksymalizacja zysku

    optimize!(model) #Rozwiązuje model
    status = termination_status(model) #Sprawdza status rozwiązania
    X = [value.(x[j]) for j in J]
    obj = objective_value(model)

    #Czas pracy każdej maszyny
    for i in I
        total_time = sum(processing_time[i, j] * X[j] for j in J)
        println("Maszyna ", i, " pracowała: ", round(total_time, digits=6), " minut (Dostępne: ", availability[i], " minut)")
    end
    println()

    #Zwracanie wyników
    println("Status: ", status)
    println("Maksymalny zysk: ", round(obj, digits=6))
    println()

    for j in J
        println("Produkt ", j, " wyprodukowano: ", round(X[j], digits=6), " jednostek (Maksymalny popyt: ", max_demand[j], ")")
    end
    println()
end

function main()
    if length(ARGS) < 1
        println("Użycie: julia production.jl <plik.toml>")
        return
    end
    processing_time, availability, max_demand, profit = loadData(ARGS[1])
    solveProductionProblem(processing_time, availability, max_demand, profit)
end

main()