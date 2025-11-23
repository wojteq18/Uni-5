include("NumericalRoots.jl")

using .NumericalRoots

function main()
    f(x) = sin(x) - (0.5x)^2
    pf(x) = cos(x) - 0.5x
    delta = 0.5 * 10.0^-5
    epsilon = 0.5 * 10.0^-5
    a = 1.5
    b = 2.0
    c = 1.0

    root_bisekcji = mbisekcji(f, a, b, delta, epsilon)
    println("Metoda bisekcji:")
    println("Przybliżenie miejsca zerowego: ", root_bisekcji[1])
    println("Wartość funkcji w przybliżeniu: ", root_bisekcji[2])
    println("Liczba iteracji: ", root_bisekcji[3])
    println("Kod błędu: ", root_bisekcji[4])
        
    root_stycznych = mstycznych(f, pf, a, delta, epsilon, 100)
    println("\nMetoda stycznych:")
    println("Przybliżenie miejsca zerowego: ", root_stycznych[1])
    println("Wartość funkcji w przybliżeniu: ", root_stycznych[2])
    println("Liczba iteracji: ", root_stycznych[3])
    println("Kod błędu: ", root_stycznych[4])

    root_siecznych = msiecznych(f, c, b, delta, epsilon, 100)
    println("\nMetoda siecznych:")
    println("Przybliżenie miejsca zerowego: ", root_siecznych[1])
    println("Wartość funkcji w przybliżeniu: ", root_siecznych[2])
    println("Liczba iteracji: ", root_siecznych[3])
    println("Kod błędu: ", root_siecznych[4])
end    

main()