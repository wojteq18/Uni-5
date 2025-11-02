#Wojciech Typer

function f(x)
    return sin(x) + cos(3 * x)
end    

function approximate_derivative(f, x, h)
    return (f(x + h) - f(x)) / h
end

function real_derivative(x)
    return cos(x) - 3 * sin(3 * x)
end

function f_prime()
    for i in 0:54
        apx_res = approximate_derivative(f, 1, 2.0^(-i))
        real_res = real_derivative(1)
        difference = abs(real_res - apx_res)
        println("h = 2^(-$i): $apx_res, Real: $real_res, Difference: $difference")
    end
end

_ = f_prime()