include("NumericalRoots.jl")

using .NumericalRoots

function main()
    a = 0.0
    b = 1.0
    c = 2.0
    f(x) = 3x - exp(x)
    delta = 0.5 * 10.0^-5
    epsilon = 0.5 * 10.0^-5

    root_bisekcji = mbisekcji(f, a, b, delta, epsilon)
    println("Metoda bisekcji (przedział [0.0, 1.0]):")
    println("Przybliżenie miejsca zerowego: ", root_bisekcji[1])
    println("Wartość funkcji w przybliżeniu: ", root_bisekcji[2])
    println("Liczba iteracji: ", root_bisekcji[3])
    println("Kod błędu: ", root_bisekcji[4])

    root_bisekcji_2 = mbisekcji(f, b, c, delta, epsilon)
    println("\nMetoda bisekcji (przedział [1.0, 2.0]):")
    println("Przybliżenie miejsca zerowego: ", root_bisekcji_2[1])
    println("Wartość funkcji w przybliżeniu: ", root_bisekcji_2[2])
    println("Liczba iteracji: ", root_bisekcji_2[3])
    println("Kod błędu: ", root_bisekcji_2[4])
end    

main()