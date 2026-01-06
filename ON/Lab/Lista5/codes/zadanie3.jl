function solve_lu(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64}, b::Vector{Float64}, p=nothing)
    # Definiujemy szerokość pasma w zależności od tego, czy używamy pivota
    bandwidth = (p === nothing) ? l : 2*l
    
    # 1. Ly = b (podstawienie w przód)
    y = zeros(n)
    for i in 1:n
        idx = (p === nothing) ? i : p[i]
        sum_val = 0.0
        # ZMIANA: Zakres j musi być spójny z dekompozycją (bandwidth)
        for j in max(1, i - bandwidth):i-1
            sum_val += get(A, (idx, j), 0.0) * y[j]
        end
        y[i] = b[idx] - sum_val
    end

    # 2. Ux = y (podstawienie wsteczne)
    x = zeros(n)
    for i in n:-1:1
        idx = (p === nothing) ? i : p[i]
        sum_val = 0.0
        # Tutaj już miałeś bandwidth, co jest poprawne
        for j in i+1:min(i + bandwidth, n)
            sum_val += get(A, (idx, j), 0.0) * x[j]
        end
        
        diag_val = get(A, (idx, i), 0.0)
        if abs(diag_val) > 1e-20
            x[i] = (y[i] - sum_val) / diag_val
        else
            x[i] = 0.0 
        end
    end
    return x
end