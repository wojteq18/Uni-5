using JuMP
using HiGHS
using TOML

function loadData(path::AbstractString)
    data = TOML.parsefile(path)

    c = Float64.(data["c"]) #koszt jednostki w danym okresie
    o = Float64.(data["o"]) #koszt jednostki w nadprodukcji
    a = Float64.(data["a"]) #możlwie nadprodukcje
    d = Float64.(data["d"]) #zapotrzebowanie w okresie
    max_prod = data["max"] #maksymalna możliwa ilość jednostek do wpyrodukowania w danym okresie bez nadprodukcji
    store_cost = data["store_cost"] # Koszt przechowywania jednej jednostki w magazynie
    s0 = data["s0"] #Ilość jednostek na początku
    S_max = data["S_max"] # Maksymalna pojemność magazynu

    return c, o, a, d, max_prod, store_cost, s0, S_max
end

function solveProductionProblem(c, o, a, d, max_prod, store_cost, s0, S_max)
    K = length(d) #liczba okresów
    model = Model(HiGHS.Optimizer) #Tworzy model optymalizacyjny, używając solvera HiGHS
    set_silent(model)

    #Zmienne decyzyjne
    @variable(model, 0 <= x[1:K] <= max_prod) #ilości produkowane w danym okresie
    @variable(model, 0 <= y[1:K]) #ilości nadprodukowane w danym okresie
    @variable(model, 0 <= S[1:K] <= S_max) #zapas na koniec okresu

    #Ograniczenia
    @constraint(model, [j in 1:K], y[j] <= a[j]) #ograniczenia nadprodukcji

    #bilans zapasów
    for j in 1:K
        if j == 1
            @constraint(model, s0 + x[1] + y[1] - S[1] == d[1])
        else
            @constraint(model, S[j-1] + x[j] + y[j] - S[j] == d[j])
        end
    end

    #funkcja celu
    @objective(model, Min, sum(c[j] * x[j] + o[j] * y[j] + store_cost * S[j] for j in 1:K))

    optimize!(model) #Rozwiązuje model
    status = termination_status(model) #Sprawdza status rozwiązania

    X = [value.(x[j]) for j in 1:K]
    Y = [value.(y[j]) for j in 1:K]
    S_vals = [value.(S[j]) for j in 1:K]
    obj = objective_value(model) #Wartość funkcji celu
    #Zwracanie wyników
    println("Status: ", status)
    println("Minimalny koszt: ", round(obj, digits=6))
    println()   
    for j in 1:K
        println("Okres ", j, ": Wyprodukowano ", round(X[j], digits=6), 
                " jednostek, Nadprodukcja: ", round(Y[j], digits=6), 
                ", Zapas na koniec okresu: ", round(S_vals[j], digits=6))
    end
end    

function main()
    if length(ARGS) < 1
        println("Użycie: julia production.jl <plik.toml>")
        return
    end
    c, o, a, d, max_prod, store_cost, s0, S_max = loadData(ARGS[1])
    solveProductionProblem(c, o, a, d, max_prod, store_cost, s0, S_max)
end

main()