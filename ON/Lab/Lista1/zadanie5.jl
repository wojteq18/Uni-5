function method_one(x, y)
    sum = 0.0
    for i in 1:length(x)
        sum += x[i] * y[i]
    end
    return sum
end

function method_two(x, y)
    sum = 0.0
    for i in length(x):-1:1
        sum = sum + x[i] * y[i]
    end
    return sum
end

function method3(x, y)
    dodatnie = Float64[]
    ujemne = Float64[]
    for i in 1:length(x)
        if x[i] * y[i] > 0
            push!(dodatnie, x[i] * y[i])
        else
            push!(ujemne, x[i] * y[i])
        end
    end
    sort!(dodatnie, rev=true)
    sort!(ujemne)

    sum_dodatnich = 0.0
    for val in dodatnie
        sum_dodatnich += val
    end

    sum_ujemnych = 0.0
    for val in ujemne
        sum_ujemnych += val
    end

    return sum_dodatnich + sum_ujemnych
end

function method4(x, y)
    dodatnie = Float64[]
    ujemne = Float64[]
    for i in 1:length(x)
        if x[i] * y[i] > 0
            push!(dodatnie, x[i] * y[i])
        else
            push!(ujemne, x[i] * y[i])
        end
    end
    sort!(dodatnie)
    sort!(ujemne, rev=true)

    sum_ujemnych = 0.0
    for val in ujemne
        sum_ujemnych += val
    end
    
    sum_dodatnich = 0.0
    for val in dodatnie
        sum_dodatnich += val
    end

    return sum_ujemnych + sum_dodatnich
end

x = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

result_one = method_one(x, y)
println("Result using method one: ", result_one)

result_two = method_two(x, y)
println("Result using method two: ", result_two)

result_three = method3(x, y)
println("Result using method three: ", result_three)

result_four = method4(x, y)
println("Result using method four: ", result_four)