using Plots

# 1. Definicja funkcji i parametrów
f(x) = x^3 - x - 2
a, b = 1.0, 2.0
iteracje = 5 # Ile kroków pokazać na wykresie

# 2. Przygotowanie danych do wykresu funkcji
x_vals = range(0.8, 2.2, length=200)
y_vals = f.(x_vals)

# 3. Rysowanie funkcji (czarna linia)
p = plot(x_vals, y_vals, label="f(x) = x^3 - x - 2", lw=2, color=:black, legend=:topleft)
plot!(p, [0.8, 2.2], [0, 0], label="", color=:gray, linestyle=:dash) # Oś X

# 4. Symulacja Bisekcji i dorysowywanie przedziałów
# Kolory dla kolejnych iteracji, żeby było widać postęp
colors = [:red, :red, :red, :red, :red]

current_a, current_b = a, b

for i in 1:iteracje
    mid = (current_a + current_b) / 2
    val = f(mid)
    
    # Rysujemy pionowe linie ograniczające aktualny przedział
    # Rysujemy "pudełko" lub linie dla danej iteracji
    plot!(p, [current_a, current_a], [0, f(current_a)], label=(i==1 ? "Iteracje" : ""), color=colors[i], linestyle=:dot)
    plot!(p, [current_b, current_b], [0, f(current_b)], label="", color=colors[i], linestyle=:dot)
    scatter!(p, [mid], [0], color=colors[i], label="", markersize=5) # Punkt na osi X
    
    # Logika bisekcji
    if f(current_a) * val < 0
        global current_b = mid
    else
        global current_a = mid
    end
end

# 5. Opis osi i tytuł
xlabel!(p, "x")
ylabel!(p, "f(x)")

# 6. Wyświetlenie i zapis
display(p)
savefig("bisekcja.png")
println("Wykres zapisano jako bisekcja.png")