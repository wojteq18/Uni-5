function read_matrix(filepath::String)
    open(filepath, "r") do f
        line = split(readline(f))
        n, l = parse(Int, line[1]), parse(Int, line[2])
        A = Dict{Tuple{Int,Int}, Float64}()
        while !eof(f)
            line = split(readline(f))
            if length(line) < 3 break end
            i, j = parse(Int, line[1]), parse(Int, line[2])
            val = parse(Float64, line[3])
            A[(i, j)] = val
        end
        return n, l, A
    end
end

function read_vector(filepath::String)
    open(filepath, "r") do f
        n = parse(Int, readline(f))
        return [parse(Float64, readline(f)) for _ in 1:n]
    end
end

function calculate_b(n::Int, l::Int, A::Dict{Tuple{Int,Int}, Float64})
    b = zeros(n)
    for ((i, j), val) in A
        b[i] += val
    end
    return b
end

function write_result(filepath::String, x::Vector{Float64}, rel_err=nothing)
    open(filepath, "w") do f
        if rel_err !== nothing println(f, rel_err) end
        for v in x println(f, v) end
    end
end