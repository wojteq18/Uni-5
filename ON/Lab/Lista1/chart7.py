import numpy as np
import matplotlib.pyplot as plt
import re

# Wczytaj dane z pliku data.tex
hs = []
vals = []
reals = []
diffs = []

with open('data7.txt', encoding='utf8') as f:
    for line in f:
        m = re.match(r"h = 2\^\(-(\d+)\):\s*([-\d\.eE]+), Real: ([-\d\.eE]+), Difference: ([\d\.eE+-]+)", line)
        if m:
            n = int(m.group(1))
            h = 2 ** (-n)
            val = float(m.group(2))
            real = float(m.group(3))
            diff = float(m.group(4))
            hs.append(h)
            vals.append(val)
            reals.append(real)
            diffs.append(diff)

hs = np.array(hs)
vals = np.array(vals)
reals = np.array(reals)
diffs = np.array(diffs)

plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.plot(hs, vals, 'o-', label='Przybliżona pochodna')
plt.axhline(reals[0], color='r', linestyle='--', label='Dokładna wartość')
plt.xscale('log', base=2)
plt.xlabel('h')
plt.ylabel("Pochodna")
plt.title("Przybliżona pochodna i dokładna wartość w zależności od h")
plt.legend()
plt.grid(True)

# Wykres błędu
plt.subplot(2, 1, 2)
plt.plot(hs, diffs, 'o-', label='|Różnica|')
plt.xscale('log', base=2)
plt.yscale('log')
plt.xlabel('h')
plt.ylabel('|Przybliżona - Dokładna|')
plt.title("Błąd przybliżenia pochodnej w zależności od h")
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()