include("functions.jl")

using .functions

function main()
    f_runge(x) = 1.0 / (1.0 + 25.0 * x^2)

    rysujNnfx(f_runge, -1.0, 1.0, 15, wezly=:rownoodlegle)
    readline()

    rysujNnfx(f_runge, -1.0, 1.0, 15, wezly=:czebyszew)
    readline()
end

main()