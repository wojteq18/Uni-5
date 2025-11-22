function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64,maxit::Int)
    fa = f(x0)
    fb = f(x1)

    for k in 1:maxit 
        if abs(fa) > abs(fb)
            x0, x1 = x1, x0
            fa, fb = fb, fa
        end

        if abs(fb - fa) < epsilon
            return x1, fb, k, 0 # Zwracamy ostatnie lepsze przybliżenie
        end
        s = (x1 - x0) / (fb - fa)
        x_new = x0 - fa * s
        f_new = f(x_new)

        if abs(x_new - x0) < delta || abs(f_new) < epsilon
            return x_new, f_new, k, 0
        end

        x1 = x0
        fb = fa
        x0 = x_new
        fa = f_new
    end    
    return x0, fa, maxit, 1
end    

function main()
    # Dane testowe: f(x) = x^2 - 2, pierwiastek to sqrt(2) ≈ 1.41421356
    f_test = x -> x^2 - 2

    # Parametry dokładności i maksymalna liczba iteracji
    delta = 1e-8
    epsilon = 1e-8
    
    println("Testowanie funkcji msiecznych")
    println("==============================")

    # --- TEST 1: POPRAWNE ZNALEZIENIE ROZWIĄZANIA ---
    println("\n--- Test 1: Poprawne znalezienie miejsca zerowego ---")
    x0_1, x1_1 = 1.0, 2.0
    maxit1 = 100
    println("Szukanie dla f(x)=x^2-2, punkty startowe: ($x0_1, $x1_1)")

    r1, v1, it1, err1 = msiecznych(f_test, x0_1, x1_1, delta, epsilon, maxit1)

    println("Znaleziony pierwiastek (r): ", r1)
    println("Wartość f(r) (v): ", v1)
    println("Liczba iteracji (it): ", it1)
    println("Kod błędu (err): ", err1)
    println("------------------------------------------------")

    # --- TEST 2: PRZYPADEK TRUDNY - FUNKCJA PŁASKA ---
    # f(x) = cos(x) w pobliżu x=0, gdzie funkcja jest bardzo płaska
    # Wartości fa i fb będą bardzo blisko siebie.
    f_plaska = x -> cos(x)
    println("\n--- Test 2: Funkcja płaska (f(x) = cos(x) blisko zera) ---")
    x0_2, x1_2 = -0.1, 0.1
    maxit2 = 100
    println("Szukanie dla f(x)=cos(x), punkty startowe: ($x0_2, $x1_2)")

    # Pierwiastek jest przy PI/2 ≈ 1.57
    r2, v2, it2, err2 = msiecznych(f_plaska, x0_2, x1_2, delta, epsilon, maxit2)

    println("Znaleziony pierwiastek (r): ", r2)
    println("Wartość f(r) (v): ", v2)
    println("Liczba iteracji (it): ", it2)
    println("Kod błędu (err): ", err2)
    println("------------------------------------------------")


    # --- TEST 3: PRZEKROCZENIE MAKSYMALNEJ LICZBY ITERACJI ---
    # Używamy tej samej funkcji co dla metody Newtona, która może oscylować
    f_oscyl = x -> x^3 - 2*x + 2
    println("\n--- Test 3: Przekroczenie maksymalnej liczby iteracji ---")
    x0_3, x1_3 = 0.0, 1.0
    maxit3 = 5 # celowo za mało iteracji
    println("Szukanie dla f(x)=x^3-2x+2, punkty startowe: ($x0_3, $x1_3), maxit=$maxit3")

    r3, v3, it3, err3 = msiecznych(f_oscyl, x0_3, x1_3, delta, epsilon, maxit3)

    println("Ostatni pierwiastek (r): ", r3)
    println("Wartość f(r) (v): ", v3)
    println("Liczba iteracji (it): ", it3)
    println("Kod błędu (err): ", err3, " (oczekiwano 1)")
    println("------------------------------------------------")
end

# Uruchomienie głównej funkcji testującej
main()
