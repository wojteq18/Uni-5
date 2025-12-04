include("functions.jl")

using .functions

function main()
    f1 = x -> abs(x)
    a1 = -1.0
    b1 = 1.0
    n1 = [5, 10, 15]

    f2 = x -> 1 / (1 + x^2)
    a2 = -5.0
    b2 = 5.0
    n2 = [5, 10, 15]

    for n in n2
        rysujNnfx(f1, a1, b1, n, wezly=:czebyszew)
        readline()
    end
end

main()