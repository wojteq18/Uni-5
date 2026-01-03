
function solve_gauss!(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64}, b::Vector{Float64})
    for k in 1:n-1
        # Zakres wierszy do eliminacji (wynika ze struktury macierzy)
        last_row = min(k + l, n) 
        if k % l == 0
             last_row = min(k + l, n)
        end
        
        for i in k+1:last_row
            if abs(get(A, (k, k), 0.0)) < eps(Float64)
                error("Zero na przekątnej w kroku: ", k)
            end
            
            factor = get(A, (i, k), 0.0) / A[(k, k)]
            A[(i, k)] = 0.0
            
            # Aktualizacja wiersza i (kolumny od k+1 do k+l)
            for j in k+1:min(k + l, n)
                val = get(A, (i, j), 0.0) - factor * get(A, (k, j), 0.0)
                if val != 0.0 A[(i, j)] = val else delete!(A, (i, j)) end
            end
            b[i] -= factor * b[k]
        end
    end

    # Podstawienie wsteczne
    x = zeros(n)
    for i in n:-1:1
        sum_val = 0.0
        for j in i+1:min(i + l, n)
            sum_val += get(A, (i, j), 0.0) * x[j]
        end
        x[i] = (b[i] - sum_val) / A[(i, i)]
    end
    return x
end


function solve_gauss_pivot!(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64}, b::Vector{Float64})
    p = collect(1:n)
    for k in 1:n-1
        # Wybór elementu głównego w obrębie pasma
        max_val = 0.0
        pivot_row = k
        for i in k:min(k + l, n)
            current_val = abs(get(A, (p[i], k), 0.0))
            if current_val > max_val
                max_val = current_val
                pivot_row = i
            end
        end
        p[k], p[pivot_row] = p[pivot_row], p[k]
        
        for i in k+1:min(k + l, n)
            factor = get(A, (p[i], k), 0.0) / A[(p[k], k)]
            A[(p[i], k)] = 0.0
            for j in k+1:min(k + 2*l, n) # Pasmo może się rozszerzyć przy wyborze głównego
                val = get(A, (p[i], j), 0.0) - factor * get(A, (p[k], j), 0.0)
                if val != 0.0 A[(p[i], j)] = val else delete!(A, (p[i], j)) end
            end
            b[p[i]] -= factor * b[p[k]]
        end
    end

    # Podstawienie wsteczne
    x = zeros(n)
    for i in n:-1:1
        sum_val = 0.0
        for j in i+1:min(i + 2*l, n)
            sum_val += get(A, (p[i], j), 0.0) * x[j]
        end
        x[i] = (b[p[i]] - sum_val) / A[(p[i], i)]
    end
    return x
end