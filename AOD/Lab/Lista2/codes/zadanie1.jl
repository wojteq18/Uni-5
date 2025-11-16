using JuMP
using HiGHS
using TOML

function loadData(path::AbstractString)
    data = TOML.parsefile(path)

    s = Float64.(data["supply"]) #dostawy
    d = Float64.(data["demand"]) #popyt
    C = reduce(vcat, [Float64.(row)' for row in data["costs"]]) #koszty transportu
    #podstawowe ograniczenia
    m, n = size(C)
    @assert length(s) == m "Liczba dostaw musi odpowiadać liczbie wierszy kosztów"
    @assert length(d) == n "Liczba popytu musi odpowiadać liczbie kolumn kosztów"
    @assert sum(s) >= sum(d) "Podaż musi być większa lub równa popytowi"

    return s, d, C
end

function solveTransportProblem(s, d, C) #s -> zaopatrzenie, d -> popyt, C -> koszty
    I = eachindex(s)
    J = eachindex(d)

    model = Model(HiGHS.Optimizer) #Tworzy model optymalizacyjny, używając solvera HiGHS
    set_silent(model) #Wyłącza wyjście solvera

    #Zmienne decyzyjne
    @variable(model, x[i in I, j in J] >= 0) #ilości transportowane

    #Ograniczenia
    @constraint(model, [i in I], sum(x[i, j] for j in J) <= s[i]) #ograniczenia dostaw
    @constraint(model, [j in J], sum(x[i, j] for i in I) == d[j]) #ograniczenia popytu

    #Funkcja celu
    @objective(model, Min, sum(C[i, j] * x[i, j] for i in I, j in J)) #minimalizacja kosztów transportu

    optimize!(model) #Rozwiązuje model
    status = termination_status(model) #Sprawdza status rozwiązania
    X = [value.(x[i, j]) for i in I, j in J]
    obj = objective_value(model)

    #Zwracanie wyników
    println("Status: ", status)
    println("Minimalny koszt: ", round(obj, digits=6))
    println()

    #Czy wszystkie firmy dostarczają paliwo?
    for i in I
        total_supplied = sum(X[i, j] for j in J)
        println("Firma ", i, " dostarczyła: ", round(total_supplied, digits=6), " jednostek paliwa (Dostępne: ", s[i], ")")
    end
    println()

    #Gdzie dana firma wysyła paliwo
    for i in I
        for j in J
            if X[i, j] > 1e-6 #Pomijamy bardzo małe wartości
                println("Firma ", i, " wysyła do stacji ", j, ": ", round(X[i, j], digits=6), " jednostek paliwa")
            end
        end
    end
end    

function main()
    if length(ARGS) < 1
        println("Użycie: julia transport.jl <plik.toml>")
        return
    end
    s, d, C = loadData(ARGS[1])
    solveTransportProblem(s, d, C)
end

main()