function method1(x::Float64)
    return (sqrt((x^2.0) + 1.0) - 1.0)
end

function method2(x::Float64)
    return (x^2.0) / (sqrt((x^2.0) + 1.0) + 1.0)
end

for i in 1:25
    num1 = method1(8.0^(-i))
    num2 = method2(8.0^(-i))
    println("For 8.0^(-", i, "):")
    println("Method 1 result: ", num1)
    println("Method 2 result: ", num2)
end

#Method 1 is a shit, 2 is more accurate