import matplotlib.pyplot as plt

# Dane wejściowe
n_labels = ["16", "10k", "50k", "100k", "500k", "750k", "1M"]
n_values = [16, 10000, 50000, 100000, 500000, 750000, 1000000]

# Dane 1: Gauss with b (odczyt z pliku)
time_with_b = [0.000209753, 0.060427987, 0.29371142, 0.533731705, 
               2.786117241, 4.245203196, 5.603734472]

# Dane 2: Gauss without b (obliczany z macierzy A)
time_without_b = [0.000260708, 0.056235582, 0.308152042, 0.593173131, 
                  3.368534508, 5.09063358, 7.094519553]

plt.figure(figsize=(10, 6))

# Rysowanie wykresów
plt.plot(n_values, time_with_b, 'o-', linewidth=2, label='Metoda Gaussa bez wyboru elementu głównego')
plt.plot(n_values, time_without_b, 's--', linewidth=2, label='Metoda Gaussa z częściowym wyborem elementu głównego')

# Konfiguracja osi i etykiet
plt.title('Porównanie czasu wykonania algorytmu Gaussa', fontsize=14)
plt.xlabel('Rozmiar macierzy (n)', fontsize=12)
plt.ylabel('Czas wykonania [s]', fontsize=12)
plt.xscale('linear') # Skala liniowa dobrze pokazuje złożoność O(n)
plt.grid(True, which="both", ls="-", alpha=0.5)

# Dodanie legendy
plt.legend(fontsize=11)

# Wyświetlenie wykresu
plt.tight_layout()
plt.show()