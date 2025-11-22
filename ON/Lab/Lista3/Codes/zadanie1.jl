function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    u = f(a)
    v = f(b)
    err = 0
    if u * v > 0
        err = 1
        return 0, 0.0, 0.0, err
    end
    e = abs(b - a)
    for k in 1:1000
        e = e / 2
        c = a + e
        w = f(c)

        if abs(e) < delta || abs(w) < epsilon
            return k, c, w, err 
        end   
        
        if w * u < 0
            b = c
            v = w 

        else 
            a = c 
            u = w    
        end    
    end
end

function main()

    f(x) = x^2 - 2

    delta = 1e-8
    epsilon = 1e-8
    
    println("Testowanie funkcji mbisekcji dla f(x) = x^2 - 2")
    println("===================================================")

    println("\n--- Test 1: Poprawne znalezienie miejsca zerowego ---")
    a1, b1 = 1.0, 2.0
    M1 = 100
    println("Szukanie w przedziale [$a1, $b1] z M = $M1")
    
    wynik1 = mbisekcji(f, a1, b1, delta, epsilon)
    k1, c1, w1, err1 = wynik1

    println("Liczba iteracji (k): ", k1)
    println("Znalezione miejsce zerowe (c): ", c1)
    println("Wartość funkcji w punkcie c (w): ", w1)
    println("Kod błędu (err): ", err1)
    println("---------------------------------------------------")


    println("\n--- Test 2: Błąd - wartości na krańcach mają ten sam znak ---")
    a2, b2 = 1.5, 2.0
    M2 = 100
    println("Szukanie w przedziale [$a2, $b2] (f(1.5) > 0, f(2.0) > 0)")
    
    wynik2 = mbisekcji(f, a2, b2, delta, epsilon)
    k2, c2, w2, err2 = wynik2

    println("Liczba iteracji (k): ", k2)
    println("Znalezione miejsce zerowe (c): ", c2)
    println("Wartość funkcji w punkcie c (w): ", w2)
    println("Kod błędu (err): ", err2)
    println("---------------------------------------------------")


    println("\n--- Test 3: Przekroczenie maksymalnej liczby iteracji ---")
    a3, b3 = 1.0, 2.0
    M3 = 5 # celowo za mało iteracji
    println("Szukanie w przedziale [$a3, $b3] z M = $M3 (za mało iteracji)")

    wynik3 = mbisekcji(f, a3, b3, delta, epsilon)

    if isnothing(wynik3)
        println("Wynik: nothing")
        println("Funkcja zakończyła działanie bez zwrócenia wartości, co jest oczekiwane,")
        println("gdyż osiągnięto limit M=$M3 iteracji przed znalezieniem rozwiązania.")
    else
        println("Test nie powiódł się - funkcja zwróciła wartość, chociaż nie powinna.")
        println("Zwrócony wynik: ", wynik3)
    end
    println("---------------------------------------------------")
end

main()