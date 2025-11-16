using JuMP
using HiGHS
using TOML

function loadData(path::AbstractString)
    d = TOML.parsefile(path)
    N     = Int(d["N"])
    from     = Int(d["from"])
    to = Int(d["to"])
    Tmax  = Float64(d["Tmax"])
    arcs_raw = d["arcs"]

    #listy łuków i atrybutów
    I = Int[]; J = Int[]; C = Float64[]; T = Float64[]
    for a in arcs_raw
        push!(I, Int(a["i"]))
        push!(J, Int(a["j"]))
        push!(C, Float64(a["c"]))
        push!(T, Float64(a["t"]))
    end
    return N, from, to, Tmax, I, J, C, T
end

function solveTransportProblem(N, from, to, Tmax, I, J, C, T)
    model = Model(HiGHS.Optimizer) #Tworzy model optymalizacyjny, używając solvera HiGHS
    set_silent(model) #Wyłącza wyjście solvera

    A = collect(1:length(I)) #Indeksy łuków

    #Lista sąsiedztw
    out_arcs = [Int[] for _ in 1:N]
    in_arcs  = [Int[] for _ in 1:N]
    for a in A
        push!(out_arcs[I[a]], a)
        push!(in_arcs[J[a]], a)
    end

    #Zmienne decyzyjne
    @variable(model, 0 <= x[a in A] <= 1) #czy łuk a jest w trasie

    #Ograniczenia
    @constraint(model, [v in 1:N], sum(x[a] for a in out_arcs[v]) - sum(x[a] for a in in_arcs[v]) == (v == from ? 1 : v == to ? -1 : 0)) #warunki przepływu
    @constraint(model, sum(T[a] * x[a] for a in A) <= Tmax) #ograniczenie czasu podróży

    #Funkcja celu
    @objective(model, Min, sum(C[a] * x[a] for a in A)) #minimalizacja kosztów

    optimize!(model) #Rozwiązuje model
    status = termination_status(model) #Sprawdza status rozwiązania
    X = [value.(x[a]) for a in A]
    obj = objective_value(model) #Wartość funkcji celu
    #Zwracanie wyników
    println("Status: ", status)
    println("Minimalny koszt: ", round(obj, digits=6))
    println()

    #Znaleziona trasa 
    for a in A 
        if X[a] > 0.5
            println("Łuk z miasta ", I[a], " do miasta ", J[a], " (Koszt: ", C[a], ", Czas: ", T[a], ")")
        end
    end
end    

function main()
    if length(ARGS) < 1
        println("Użycie: julia transport_time_cost.jl <plik.toml>")
        return
    end
    N, from, to, Tmax, I, J, C, T = loadData(ARGS[1])
    solveTransportProblem(N, from, to, Tmax, I, J, C, T)
end

main()