
function lu_decomp!(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64})
    for k in 1:n-1
        for i in k+1:min(k + l, n)
            factor = get(A, (i, k), 0.0) / A[(k, k)]
            A[(i, k)] = factor # Przechowywanie L w dolnej części
            for j in k+1:min(k + l, n)
                val = get(A, (i, j), 0.0) - factor * get(A, (k, j), 0.0)
                if val != 0.0 A[(i, j)] = val else delete!(A, (i, j)) end
            end
        end
    end
end


function lu_decomp_pivot!(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64})
    p = collect(1:n)
    for k in 1:n-1
        max_val = 0.0
        pivot_idx = k
        for i in k:min(k + l, n)
            if abs(get(A, (p[i], k), 0.0)) > max_val
                max_val = abs(get(A, (p[i], k), 0.0))
                pivot_idx = i
            end
        end
        p[k], p[pivot_idx] = p[pivot_idx], p[k]

        for i in k+1:min(k + l, n)
            factor = get(A, (p[i], k), 0.0) / A[(p[k], k)]
            A[(p[i], k)] = factor
            for j in k+1:min(k + 2*l, n)
                val = get(A, (p[i], j), 0.0) - factor * get(A, (p[k], j), 0.0)
                if val != 0.0 A[(p[i], j)] = val else delete!(A, (p[i], j)) end
            end
        end
    end
    return p
end