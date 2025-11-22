using Plots

# 1. Definicja funkcji
# Używamy tej samej co przy Newtonie dla porównania: f(x) = x^3 - 2x - 2
# Pierwiastek to ok. 1.769
f(x) = x^3 - 2x - 2

# Punkty startowe (Metoda siecznych wymaga dwóch!)
x0 = 2.6
x1 = 2.4 
iteracje = 3  # 3 iteracje wystarczą, by pokazać ideę (szybka zbieżność)

# 2. Przygotowanie wykresu tła
x_range = range(1.5, 2.8, length=200)
y_vals = f.(x_range)

p = plot(x_range, y_vals, label="f(x) = x^3 - 2x - 2", lw=2, color=:black, legend=:topleft)
plot!(p, [1.5, 2.8], [0, 0], label="", color=:gray, linestyle=:dash) # Oś X

# 3. Symulacja Metody Siecznych
# Potrzebujemy zmiennych do przechowywania poprzednich wartości
prev_x = x0
curr_x = x1
colors = [:red, :blue, :green]

for i in 1:iteracje
    # Obliczamy wartości funkcji w punktach
    y_prev = f(prev_x)
    y_curr = f(curr_x)
    
    # Wzór metody siecznych na nowe przybliżenie
    next_x = curr_x - y_curr * (curr_x - prev_x) / (y_curr - y_prev)
    
    # KROK A: Zaznaczamy dwa punkty, przez które przechodzi sieczna
    # (Tylko w 1. iteracji zaznaczamy oba wyraźnie, w kolejnych to "wędruje")
    if i == 1
        scatter!(p, [prev_x], [y_prev], color=colors[i], markersize=4, label="Punkty startowe")
    end
    scatter!(p, [curr_x], [y_curr], color=colors[i], markersize=4, label="")
    
    # KROK B: Rysujemy linię sieczną
    # Sieczna przechodzi przez (prev_x, y_prev) i (curr_x, y_curr) i celuje w (next_x, 0)
    # Rysujemy linię od "najdalszego" punktu aż do osi X
    plot!(p, [prev_x, next_x], [y_prev, 0], 
          color=colors[i], linewidth=1.5, label="Sieczna $i")
          
    # KROK C: Zaznaczamy nowe przybliżenie na osi X
    scatter!(p, [next_x], [0], 
             shape=:xcross, color=colors[i], markersize=6, label="Nowe przybliżenie x$(i+1)")
    
    # Wyświetlenie linii pomocniczych (pionowych) dla lepszej czytelności
    plot!(p, [curr_x, curr_x], [0, y_curr], linestyle=:dot, color=colors[i], alpha=0.5, label="")
    
    # Aktualizacja zmiennych (przesunięcie okna)
    global prev_x = curr_x
    global curr_x = next_x
end

# 4. Opis i zapis
xlabel!(p, "x")
ylabel!(p, "f(x)")

display(p)
savefig("sieczne.png")
println("Wykres zapisano jako sieczne.png")