include("functions.jl")

using .functions

function main()
    f1 = x -> exp(x)
    a1 = 0.0
    b1 = 1.0
    n1 = [5, 10, 15]

    f2 = x -> x^2 * sin(x)
    a2 = -1.0
    b2 = 1.0
    n2 = [5, 10, 15]

    for n in n2
        rysujNnfx(f2, a2, b2, n, wezly=:rownoodlegle)
        readline()
    end
end

main()