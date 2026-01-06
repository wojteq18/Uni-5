include("blocksys.jl")
using .blocksys
using LinearAlgebra
using Printf

# MODYFIKACJA: Funkcja teraz zwraca błąd 'err'
function run_analysis(matrix_path, vector_path, method, use_pivot, out_path)
    n, l, A = read_matrix(matrix_path)
    
    b = (vector_path !== nothing) ? read_vector(vector_path) : calculate_b(n, l, A)
    
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

    # Obliczenie błędu
    err = norm(x .- ones(n)) / norm(ones(n)) 
    write_result(out_path, x, err)
    
    return err # Zwracamy błąd do wykorzystania w pętli
end

directory_names = ["Dane16_1_1", "Dane10000_1_1", "Dane50000_1_1", "Dane100000_1_1", "Dane500000_1_1", "Dane750000_1_1", "Dane1000000_1_1"]

# Listy na błędy
err2a_list = []
err2b_list = []

# Pętle Gauss (pozostają bez zmian w logice zapisu plików)
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

# MODYFIKACJA: Zbieranie błędów dla zadania 2a (LU bez pivota)
for directory_name in directory_names
    input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
    output_path = "../results/2a_results/wynik_$(directory_name).txt"
    err = run_analysis(input_path, nothing, :lu, false, output_path)
    push!(err2a_list, (directory_name, err))
end

# MODYFIKACJA: Zbieranie błędów dla zadania 2b (LU z pivotem)
for directory_name in directory_names
    input_path = "/home/wojteq18/sem5/ON/Lab/Lista5/tests/$(directory_name)/A.txt"
    output_path = "../results/2b_results/wynik_$(directory_name).txt"
    err = run_analysis(input_path, nothing, :lu, true, output_path)
    push!(err2b_list, (directory_name, err))
end

# NOWE: Zapisywanie samych błędów do dedykowanych plików
open("err2a.txt", "w") do f
    for (name, err) in err2a_list
        println(f, "$(name) $(err)")
    end
end

open("err2b.txt", "w") do f
    for (name, err) in err2b_list
        println(f, "$(name) $(err)")
    end
end

# Sekcja pomiaru czasu (pozostaje bez zmian, nadpisze wyniki ale z zachowaniem formatu)
# ... (reszta Twojego kodu z blokami time_gauss, time_2a, time_2b)