include("blocksys.jl")
using .blocksys
using LinearAlgebra
using Printf

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

    err = norm(x .- ones(n)) / norm(ones(n)) 
    write_result(out_path, x, err)
end

directory_names = ["Dane16_1_1", "Dane10000_1_1", "Dane50000_1_1", "Dane100000_1_1", "Dane500000_1_1", "Dane750000_1_1", "Dane1000000_1_1"]

for directory_name in directory_names
    A_input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
    b_input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/b.txt"
    output_path = "../results/gauss_result_with_b/wynik_gauss_$(directory_name).txt"
    run_analysis(A_input_path, b_input_path, :gauss, false, output_path)
end

for directory_name in directory_names
    A_input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
    output_path = "../results/gauss_result_without_b/wynik_gauss_$(directory_name).txt"
    run_analysis(A_input_path, nothing, :gauss, true, output_path)
end

for directory_name in directory_names
    input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
    output_path = "../results/2a_results/wynik_$(directory_name).txt"
    run_analysis(input_path, nothing, :lu, false, output_path)
end

for directory_name in directory_names
    input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
    output_path = "../results/2b_results/wynik_$(directory_name).txt"
    run_analysis(input_path, nothing, :lu, true, output_path)
end

# time
open("time_gauss_with_b.txt", "w") do t_file
    for directory_name in directory_names
        A_input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
        b_input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/b.txt"
        output_path = "../results/gauss_result_with_b/wynik_gauss_$(directory_name).txt"
        
        # Mierzymy czas wykonania
        elapsed = @elapsed run_analysis(A_input_path, b_input_path, :gauss, false, output_path)
        
        println(t_file, "$(directory_name) $(elapsed)")
        println("Ukończono Gauss (with b): $(directory_name) w czasie $(elapsed)s")
    end
end

open("time_gauss_without_b.txt", "w") do t_file
    for directory_name in directory_names
        A_input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
        output_path = "../results/gauss_result_without_b/wynik_gauss_$(directory_name).txt"
        
        elapsed = @elapsed run_analysis(A_input_path, nothing, :gauss, true, output_path)
        
        println(t_file, "$(directory_name) $(elapsed)")
        println("Ukończono Gauss (without b, pivot): $(directory_name) w czasie $(elapsed)s")
    end
end

open("time_2a.txt", "w") do t_file
    for directory_name in directory_names
        input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
        output_path = "../results/2a_results/wynik_$(directory_name).txt"
        
        elapsed = @elapsed run_analysis(input_path, nothing, :lu, false, output_path)
        
        println(t_file, "$(directory_name) $(elapsed)")
        println("Ukończono LU (2a): $(directory_name) w czasie $(elapsed)s")
    end
end

open("time_2b.txt", "w") do t_file
    for directory_name in directory_names
        input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
        output_path = "../results/2b_results/wynik_$(directory_name).txt"
        
        elapsed = @elapsed run_analysis(input_path, nothing, :lu, true, output_path)
        
        println(t_file, "$(directory_name) $(elapsed)")
        println("Ukończono LU (2b, pivot): $(directory_name) w czasie $(elapsed)s")
    end
end