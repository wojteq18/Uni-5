using Plots

# 1. Definicja funkcji i jej pochodnej
# Użyjmy funkcji f(x) = x^3 - 2x - 2
# Jej pochodna to f'(x) = 3x^2 - 2
f(x) = x^3 - 2x - 2
pf(x) = 3x^2 - 2

# Parametry startowe
x0 = 2.5          # Punkt startowy (wybrany tak, żeby było widać drogę do pierwiastka)
iteracje = 4      # Newton jest szybki, 4 iteracje wystarczą

# 2. Rysowanie tła (wykres funkcji)
x_range = range(1.0, 2.7, length=200)
y_vals = f.(x_range)

p = plot(x_range, y_vals, label="f(x) = x^3 - 2x - 2", lw=2, color=:black, legend=:topleft)
plot!(p, [1.0, 2.7], [0, 0], label="", color=:gray, linestyle=:dash) # Oś X

# 3. Symulacja Metody Newtona i rysowanie
curr_x = x0
colors = [:red, :red, :red, :red]

for i in 1:iteracje
    val = f(curr_x)
    deriv = pf(curr_x)
    
    # Obliczenie następnego punktu ze wzoru Newtona
    next_x = curr_x - val / deriv
    
    # KROK A: Rysujemy pionową linię od osi X do punktu na krzywej
    plot!(p, [curr_x, curr_x], [0, val], 
          linestyle=:dot, color=colors[i], label="")
    
    # Zaznaczamy punkt na krzywej
    scatter!(p, [curr_x], [val], 
             color=colors[i], markersize=4, label=(i==1 ? "Punkty na krzywej" : ""))
    
    # KROK B: Rysujemy styczną
    # Styczna łączy punkt na krzywej (curr_x, val) z nowym punktem na osi X (next_x, 0)
    plot!(p, [curr_x, next_x], [val, 0], 
          color=colors[i], linewidth=1.5, label=(i==1 ? "Styczne" : ""))
    
    # Zaznaczamy nowe przybliżenie na osi X
    scatter!(p, [next_x], [0], 
             shape=:xcross, color=colors[i], markersize=5, label=(i==1 ? "Nowe przybliżenia" : ""))
    
    # Aktualizacja punktu do następnej iteracji
    global curr_x = next_x
end

# 4. Opisy i zapis
xlabel!(p, "x")
ylabel!(p, "f(x)")

display(p)
savefig("newton.png")
println("Wykres zapisano jako newton.png")