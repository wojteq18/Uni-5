
function solve_lu(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64}, b::Vector{Float64}, p=nothing)
    # 1. Ly = b (podstawienie w przód)
    y = zeros(n)
    for i in 1:n
        idx = (p === nothing) ? i : p[i]
        sum_val = 0.0
        # W L elementy niezerowe są w paśmie pod przekątną
        for j in max(1, i-l-1):i-1
            sum_val += get(A, (idx, j), 0.0) * y[j]
        end
        y[i] = b[idx] - sum_val
    end

    # 2. Ux = y (podstawienie wsteczne)
    x = zeros(n)
    bandwidth = (p === nothing) ? l : 2*l
    for i in n:-1:1
        idx = (p === nothing) ? i : p[i]
        sum_val = 0.0
        for j in i+1:min(i + bandwidth, n)
            sum_val += get(A, (idx, j), 0.0) * x[j]
        end
        x[i] = (y[i] - sum_val) / A[(idx, i)]
    end
    return x
end