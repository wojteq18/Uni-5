function mstycznych(f,pf,x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)

    if abs(v) < epsilon
        return x0, v, 0, 0
    end
    
    for it in 1:maxit 
        pv = pf(x0)

        if abs(pv) < epsilon
            return x0, v, it, 2
        end

        x1 = x0 - v / pv
        v = f(x1)

        if abs(x1 - x0) < delta || abs(v) < epsilon
            return x1, v, it, 0
        end

        x0 = x1
    end    

    return x0, v, maxit, 1
end    

function main()
    f_test = x -> x^2 - 2
    pf_test = x -> 2*x

    delta = 1e-8
    epsilon = 1e-8
    
    println("Testowanie funkcji mstycznych (metoda Newtona)")
    println("================================================")

    println("\n--- Test 1: Poprawne znalezienie miejsca zerowego ---")
    x0_1 = 1.0  # Dobry punkt startowy
    maxit1 = 100
    println("Szukanie dla f(x)=x^2-2, x0 = $x0_1, maxit = $maxit1")

    r1, v1, it1, err1 = mstycznych(f_test, pf_test, x0_1, delta, epsilon, maxit1)

    println("Znaleziony pierwiastek (r): ", r1)
    println("Wartość f(r) (v): ", v1)
    println("Liczba iteracji (it): ", it1)
    println("Kod błędu (err): ", err1)
    println("------------------------------------------------")

    println("\n--- Test 2: Błąd - pochodna bliska zeru ---")
    x0_2 = 1e-9 # Punkt startowy bardzo blisko zera, gdzie pochodna jest mała
    maxit2 = 100
    println("Szukanie dla f(x)=x^2-2, x0 = $x0_2 (blisko zera)")
    
    r2, v2, it2, err2 = mstycznych(f_test, pf_test, x0_2, delta, epsilon, maxit2)

    println("Ostatni pierwiastek (r): ", r2)
    println("Wartość f(r) (v): ", v2)
    println("Liczba iteracji (it): ", it2)
    println("Kod błędu (err): ", err2, " (oczekiwano 2)")
    println("------------------------------------------------")


    f_oscyl = x -> x^3 - 2*x + 2
    pf_oscyl = x -> 3*x^2 - 2

    println("\n--- Test 3: Przekroczenie maksymalnej liczby iteracji ---")
    x0_3 = 0.0
    maxit3 = 5 # celowo za mało iteracji, żeby wpadło w pułapkę
    println("Szukanie dla f(x)=x^3-2x+2, x0 = $x0_3, maxit = $maxit3")

    r3, v3, it3, err3 = mstycznych(f_oscyl, pf_oscyl, x0_3, delta, epsilon, maxit3)

    println("Ostatni pierwiastek (r): ", r3)
    println("Wartość f(r) (v): ", v3)
    println("Liczba iteracji (it): ", it3)
    println("Kod błędu (err): ", err3, " (oczekiwano 1)")
    println("------------------------------------------------")
end

main()