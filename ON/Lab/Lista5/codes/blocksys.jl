module blocksys

using LinearAlgebra

export read_matrix, read_vector, write_result, calculate_b
export solve_gauss!, solve_gauss_pivot!, lu_decomp!, lu_decomp_pivot!, solve_lu

include("io_utils.jl")
include("zadanie1.jl")
include("zadanie2.jl")
include("zadanie3.jl")

end