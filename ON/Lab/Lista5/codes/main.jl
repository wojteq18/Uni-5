include("blocksys.jl")
using .blocksys
using LinearAlgebra

function run_analysis(matrix_path, vector_path, method, use_pivot, out_path)
    n, l, A = read_matrix(matrix_path)
    
    b = (vector_path !== nothing) ? read_vector(vector_path) : calculate_b(n, l, A)
    is_gen = (vector_path === nothing)

    if method == :gauss
        x = use_pivot ? solve_gauss_pivot!(n, l, A, b) : solve_gauss!(n, l, A, b)
    else
        if use_pivot
            p = lu_decomp_pivot!(n, l, A)
            x = solve_lu(n, l, A, b, p)
        else
            lu_decomp!(n, l, A)
            x = solve_lu(n, l, A, b)
        end
    end

    err = is_gen ? norm(x .- ones(n)) / norm(ones(n)) : nothing
    write_result(out_path, x, err)
end

run_analysis("/home/wojteq18/sem5/ON/Lab/Lista5/tests/Dane16_1_1/A.txt", nothing, :gauss, true, "wynik_gauss.txt")
run_analysis("/home/wojteq18/sem5/ON/Lab/Lista5/tests/Dane16_1_1/A.txt", "/home/wojteq18/sem5/ON/Lab/Lista5/tests/Dane16_1_1/b.txt", :lu, false, "wynik_2b.txt")