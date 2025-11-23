include("NumericalRoots.jl")

using .NumericalRoots

function main()
    f(x) = exp(1-x) - 1
    a = 0.0
    b = 2.0
    delta = 10.0^-5
    epsilon = 10.0^-5
    x0 = 10.0
    maxit = 100
    pf(x) = -exp(1 - x)
    root_bisekcji = mbisekcji(f, a, b, delta, epsilon)
    println("Metoda bisekcji:")
    println("Przybliżenie miejsca zerowego: ", root_bisekcji[1])
    println("Wartość funkcji w przybliżeniu: ", root_bisekcji[2])
    println("Liczba iteracji: ", root_bisekcji[3])
    println("Kod błędu: ", root_bisekcji[4])

    root_newtona = mstycznych(f, pf, x0, delta, epsilon, maxit)
    println("\nMetoda Newtona:")
    println("Przybliżenie miejsca zerowego: ", root_newtona[1])
    println("Wartość funkcji w przybliżeniu: ", root_newtona[2])
    println("Liczba iteracji: ", root_newtona[3])
    println("Kod błędu: ", root_newtona[4])

    root_siecznych = msiecznych(f, a, b, delta, epsilon, maxit)
    println("\nMetoda siecznych:")
    println("Przybliżenie miejsca zerowego: ", root_siecznych[1])
    println("Wartość funkcji w przybliżeniu: ", root_siecznych[2])
    println("Liczba iteracji: ", root_siecznych[3])
    println("Kod błędu: ", root_siecznych[4])

end

main()