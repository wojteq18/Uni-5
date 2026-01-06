#Wojciech Typer 279730

module blocksys

using LinearAlgebra

export BlockMatrix, BorderMatrix, CMatrix, read_block_matrix,
       solve_no_pivot, solve_pivot,
       compute_lu_no_pivot!, compute_lu_pivot!,
       solve_from_lu_no_pivot, solve_from_lu_pivot

struct BorderMatrix{T}
    l::Int
    top_row::Vector{T}
    right_column::Vector{T}
end

struct CMatrix{T}
    l::Int
    diag::Vector{T}
end

struct BlockMatrix{T}
    l::Int
    v::Int
    A::Vector{Matrix{T}}
    B::Vector{BorderMatrix{T}}
    C::Vector{CMatrix{T}}
end

function read_block_matrix(filepath::String)
    open(filepath, "r") do f
        line = split(readline(f))
        n, l = parse(Int, line[1]), parse(Int, line[2])
        v = div(n, l)
        
        As = [zeros(Float64, l, l) for _ in 1:v]
        Bs = [BorderMatrix(l, zeros(Float64, l), zeros(Float64, l)) for _ in 1:v-1]
        Cs = [CMatrix(l, zeros(Float64, l)) for _ in 1:v-1]

        while !eof(f)
            ln = split(readline(f))
            if length(ln) < 3; break; end
            i, j, val = parse(Int, ln[1]), parse(Int, ln[2]), parse(Float64, ln[3])
            
            bi, bj = div(i-1, l) + 1, div(j-1, l) + 1
            li, lj = (i-1)%l + 1, (j-1)%l + 1

            if bi == bj
                As[bi][li, lj] = val
            elseif bi == bj + 1
                if li == 1; Bs[bj].top_row[lj] = val; end
                if lj == l; Bs[bj].right_column[li] = val; end
            elseif bj == bi + 1
                if li == lj; Cs[bi].diag[li] = val; end
            end
        end
        return BlockMatrix(l, v, As, Bs, Cs)
    end
end

function lu_dense!(A::Matrix{T}) where T #wykonuje LU macierzy gęstej A bez pivota
    n = size(A, 1)
    for k in 1:n-1
        for i in k+1:n
            factor = A[i, k] / A[k, k]
            A[i, k] = factor 
            for j in k+1:n; A[i, j] -= factor * A[k, j]; end
        end
    end
end

function lu_dense_pivot!(A::Matrix{T}) where T  #wykonuje LU macierzy gęstej A z pivotem
    n = size(A, 1)
    p = collect(1:n)
    for k in 1:n-1
        max_val, max_idx = abs(A[k,k]), k
        for i in k+1:n
            if abs(A[i,k]) > max_val; max_val, max_idx = abs(A[i,k]), i; end
        end
        if max_idx != k
            A[k, :], A[max_idx, :] = A[max_idx, :], A[k, :]
            p[k], p[max_idx] = p[max_idx], p[k]
        end
        for i in k+1:n
            factor = A[i, k] / A[k, k]
            A[i, k] = factor
            for j in k+1:n; A[i, j] -= factor * A[k, j]; end
        end
    end
    return p
end

function solve_L!(A_lu::Matrix{T}, b::AbstractVector{T}, p::Vector{Int}=Int[]) where T #Podstawienie w przód: Ly = b, gdzie L jest macierzą dolnotrójkątną
    #jeśli p nie jest pusta, to b jest permutowane zgodnie z p
    n = size(A_lu, 1)
    if !isempty(p)
        b_copy = copy(b)
        for i in 1:n; b[i] = b_copy[p[i]]; end
    end
    for i in 2:n
        s = zero(T)
        for j in 1:i-1; s += A_lu[i, j] * b[j]; end
        b[i] -= s
    end
end

function solve_U!(A_lu::Matrix{T}, b::AbstractVector{T}) where T #Podstawienie wsteczne: rozwiazuje Ux = y, z macierza gornotrójkątna U
    n = size(A_lu, 1)
    for i in n:-1:1
        s = zero(T)
        for j in i+1:n; s += A_lu[i, j] * b[j]; end
        b[i] = (b[i] - s) / A_lu[i, i]
    end
end

function compute_W_matrix(A_lu::Matrix{T}, C_diag::Vector{T}, p::Vector{Int}=Int[]) where T #Oblicza macierz pomocnicza W, ktora jest zdefiniowana jako 
    #W = A_k^{-1} C_k, gdzie C_k to macierz diagonalna
    l = size(A_lu, 1)
    W = zeros(T, l, l)
    for col in 1:l
        rhs = zeros(T, l)
        rhs[col] = C_diag[col]

        solve_L!(A_lu, rhs, p); solve_U!(A_lu, rhs)
        W[:, col] = rhs
    end
    return W
end

function mul_sub_B_W!(A_next::Matrix{T}, B::BorderMatrix{T}, W::Matrix{T}) where T #Wykonuje aktualizacje kolejnego bloku diagonalnego:
    #A_{k+1} = A_{k+1} - B_k * W
    l = B.l
    for col in 1:l
        v = dot(B.top_row, W[:, col])
        A_next[1, col] -= v
        for row in 2:l; A_next[row, col] -= B.right_column[row] * W[l, col]; end
    end
end

#GŁÓWNE ALGORYTMY (O(n))
function solve_no_pivot(M::BlockMatrix{T}, b::Vector{T}) where T
    x, As, l, v = copy(b), deepcopy(M.A), M.l, M.v
    for k in 1:v
        lu_dense!(As[k])
        r_k = (k-1)*l+1 : k*l
        solve_L!(As[k], view(x, r_k))
        if k < v
            W = compute_W_matrix(As[k], M.C[k].diag)
            mul_sub_B_W!(As[k+1], M.B[k], W)
            z = copy(x[r_k]); solve_U!(As[k], z)
            r_n = k*l+1 : (k+1)*l
            x[r_n[1]] -= dot(M.B[k].top_row, z)
            for i in 2:l; x[r_n[i]] -= M.B[k].right_column[i] * z[l]; end
        end
    end
    solve_U!(As[v], view(x, (v-1)*l+1 : v*l))
    for k in v-1:-1:1
        r_k, r_n = (k-1)*l+1 : k*l, k*l+1 : (k+1)*l
        corr = M.C[k].diag .* x[r_n]
        solve_L!(As[k], corr); x[r_k] .-= corr; solve_U!(As[k], view(x, r_k))
    end
    return x
end

function solve_pivot(M::BlockMatrix{T}, b::Vector{T}) where T
    x, As, l, v = copy(b), deepcopy(M.A), M.l, M.v
    perms = [lu_dense_pivot!(As[k]) for k in 1:v]
    for k in 1:v
        r_k = (k-1)*l+1 : k*l
        solve_L!(As[k], view(x, r_k), perms[k])
        if k < v
            W = compute_W_matrix(As[k], M.C[k].diag, perms[k])
            mul_sub_B_W!(As[k+1], M.B[k], W)
            z = copy(x[r_k]); solve_U!(As[k], z)
            r_n = k*l+1 : (k+1)*l
            x[r_n[1]] -= dot(M.B[k].top_row, z)
            for i in 2:l; x[r_n[i]] -= M.B[k].right_column[i] * z[l]; end
        end
    end
    solve_U!(As[v], view(x, (v-1)*l+1 : v*l))
    for k in v-1:-1:1
        r_k, r_n = (k-1)*l+1 : k*l, k*l+1 : (k+1)*l
        p = perms[k]
        corr = (M.C[k].diag .* x[r_n])[p]
        solve_L!(As[k], corr); x[r_k] .-= corr; solve_U!(As[k], view(x, r_k))
    end
    return x
end

function compute_lu_no_pivot!(M::BlockMatrix{T}) where T
    for k in 1:M.v
        lu_dense!(M.A[k])
        if k < M.v
            W = compute_W_matrix(M.A[k], M.C[k].diag); mul_sub_B_W!(M.A[k+1], M.B[k], W)
        end
    end
end

function compute_lu_pivot!(M::BlockMatrix{T}) where T
    perms = Vector{Vector{Int}}(undef, M.v)
    for k in 1:M.v
        perms[k] = lu_dense_pivot!(M.A[k])
        if k < M.v
            W = compute_W_matrix(M.A[k], M.C[k].diag, perms[k]); mul_sub_B_W!(M.A[k+1], M.B[k], W)
        end
    end
    return perms
end

function solve_from_lu_no_pivot(M::BlockMatrix{T}, b::Vector{T}) where T
    x, l, v = copy(b), M.l, M.v
    for k in 1:v
        r_c = (k-1)*l+1 : k*l
        if k > 1
            z = copy(x[(k-2)*l+1 : (k-1)*l]); solve_U!(M.A[k-1], z)
            x[r_c[1]] -= dot(M.B[k-1].top_row, z)
            for i in 2:l; x[r_c[i]] -= M.B[k-1].right_column[i] * z[l]; end
        end
        solve_L!(M.A[k], view(x, r_c))
    end
    solve_U!(M.A[v], view(x, (v-1)*l+1 : v*l))
    for k in v-1:-1:1
        r_k, r_n = (k-1)*l+1 : k*l, k*l+1 : (k+1)*l
        corr = M.C[k].diag .* x[r_n]
        solve_L!(M.A[k], corr); x[r_k] .-= corr; solve_U!(M.A[k], view(x, r_k))
    end
    return x
end

function solve_from_lu_pivot(M::BlockMatrix{T}, perms::Vector{Vector{Int}}, b::Vector{T}) where T
    x, l, v = copy(b), M.l, M.v
    for k in 1:v
        r_c = (k-1)*l+1 : k*l
        if k > 1
            z = copy(x[(k-2)*l+1 : (k-1)*l]); solve_U!(M.A[k-1], z)
            x[r_c[1]] -= dot(M.B[k-1].top_row, z)
            for i in 2:l; x[r_c[i]] -= M.B[k-1].right_column[i] * z[l]; end
        end
        solve_L!(M.A[k], view(x, r_c), perms[k])
    end
    solve_U!(M.A[v], view(x, (v-1)*l+1 : v*l))
    for k in v-1:-1:1
        r_k, r_n = (k-1)*l+1 : k*l, k*l+1 : (k+1)*l
        p = perms[k]
        corr = (M.C[k].diag .* x[r_n])[p]
        solve_L!(M.A[k], corr); x[r_k] .-= corr; solve_U!(M.A[k], view(x, r_k))
    end
    return x
end

end