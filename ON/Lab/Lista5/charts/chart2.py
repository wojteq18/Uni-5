import matplotlib.pyplot as plt

# 1. Przygotowanie danych (rozmiary n)
n_labels = ["16", "10k", "50k", "100k", "500k", "750k", "1M"]
n_values = [16, 10000, 50000, 100000, 500000, 750000, 1000000]

# 2. Błędy względne (Relative Errors)
# Dane dla metody z częściowym wyborem elementu głównego (Gauss Pivot)
err_pivot = [
    0.03568582571775241, 0.027061784208492243, 0.027583159610778046,
    0.02677824757530304, 0.026422930697121094, 0.026789077545660945,
    0.02664028272444879
]

# Dane dla metody bez wyboru elementu głównego (Gauss)
err_no_pivot = [
    7.33293693190468e-16, 3.032762206462114e-14, 9.850881327755731e-14,
    1.2039340197172017e-13, 1.1182423082513538e-12, 4.649390521914445e-13,
    8.568966086229733e-14
]

# 3. Tworzenie wykresu
plt.figure(figsize=(10, 6))

plt.plot(n_values, err_pivot, marker='o', linestyle='-', color='red', label='Gauss z pivotingiem')
plt.plot(n_values, err_no_pivot, marker='s', linestyle='--', color='blue', label='Gauss bez pivota')

# 4. Kluczowe ustawienie: Skala logarytmiczna dla osi Y
plt.yscale('log')

# 5. Formatowanie wyglądu
plt.title('Porównanie błędu względnego rozwiązań', fontsize=14)
plt.xlabel('Rozmiar macierzy n', fontsize=12)
plt.ylabel('Błąd względny (skala logarytmiczna)', fontsize=12)

# Ustawienie etykiet na osi X
plt.xticks(n_values, n_labels)

# Dodanie siatki i legendy
plt.grid(True, which="both", linestyle=':', alpha=0.7)
plt.legend()

# 6. Wyświetlenie wykresu
plt.tight_layout()
plt.show()