#Wojciech Typer

function method_one(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat #T<:AbstractFloat -> Funkcja działa dla Float16, Float32, Float64
    sum = zero(T)
    for i in 1:length(x)
        sum += x[i] * y[i]
    end
    return sum
end

function method_two(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    sum = zero(T)
    for i in length(x):-1:1
        sum += x[i] * y[i]
    end
    return sum
end

function method3(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    dodatnie = Vector{T}()
    ujemne = Vector{T}()
    for i in 1:length(x)
        if x[i] * y[i] > 0
            push!(dodatnie, x[i] * y[i])
        else
            push!(ujemne, x[i] * y[i])
        end
    end
    sort!(dodatnie, rev=true)
    sort!(ujemne)

    sum_dodatnich = zero(T)
    for val in dodatnie
        sum_dodatnich += val
    end

    sum_ujemnych = zero(T)
    for val in ujemne
        sum_ujemnych += val
    end

    return sum_dodatnich + sum_ujemnych
end

function method4(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    dodatnie = Vector{T}()
    ujemne = Vector{T}()
    for i in 1:length(x)
        if x[i] * y[i] > 0
            push!(dodatnie, x[i] * y[i])
        else
            push!(ujemne, x[i] * y[i])
        end
    end
    sort!(dodatnie)
    sort!(ujemne, rev=true)

    sum_ujemnych = zero(T)
    for val in ujemne
        sum_ujemnych += val
    end

    sum_dodatnich = zero(T)
    for val in dodatnie
        sum_dodatnich += val
    end

    return sum_ujemnych + sum_dodatnich
end

x_64 = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
y_64 = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

x_32 = Float32.(x_64)
y_32 = Float32.(y_64)

result_one = method_one(x_64, y_64)
println("Result using method one: ", result_one)

result_two = method_two(x_64, y_64)
println("Result using method two: ", result_two)

result_three = method3(x_64, y_64)
println("Result using method three: ", result_three)

result_four = method4(x_64, y_64)
println("Result using method four: ", result_four)

println("FLOAT32:")
result_one_32 = method_one(x_32, y_32)
println("Result using method one: ", result_one_32)

result_two_32 = method_two(x_32, y_32)
println("Result using method two: ", result_two_32)

result_three_32 = method3(x_32, y_32)
println("Result using method three: ", result_three_32)
    
result_four_32 = method4(x_32, y_32)
println("Result using method four: ", result_four_32)