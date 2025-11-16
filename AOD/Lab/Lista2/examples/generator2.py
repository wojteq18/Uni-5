import networkx as nx
import matplotlib.pyplot as plt

# 1. Zdefiniowanie krawędzi grafu (hardcode)
# Format: (start, koniec, {'c': koszt, 't': czas})
edges_with_data = [
    (1, 4, {'c': 1, 't': 5}),    # Ścieżka A: Szybka i droga
    (1, 2, {'c': 5, 't': 1}),     # Ścieżka B: Tania i wolna (część 1)
    (2, 3, {'c': 1, 't': 5}),     # Ścieżka B: (część 2)
    (4, 3, {'c': 1, 't': 5}),     # Ścieżka B: (część 3)
]

# 2. Utworzenie grafu skierowanego
G = nx.DiGraph()
for u, v, data in edges_with_data:
    G.add_edge(u, v, **data)

# 3. Przygotowanie do rysowania
# Układ wierzchołków dla lepszej czytelności
pos = {1: [0, 0.5], 2: [0.33, 0], 3: [0.66, 0], 4: [1, 0.5]}

# Etykiety na krawędziach w formacie "c: [koszt], t: [czas]"
edge_labels = {
    (u, v): f"c: {d['c']}, t: {d['t']}" 
    for u, v, d in G.edges(data=True)
}

# 4. Rysowanie grafu
plt.figure(figsize=(10, 6))

nx.draw(
    G, 
    pos, 
    with_labels=True, 
    node_color='skyblue', 
    node_size=2500, 
    font_size=12, 
    font_weight='bold',
    arrows=True,
    arrowsize=20
)

nx.draw_networkx_edge_labels(
    G, 
    pos,
    edge_labels=edge_labels,
    font_color='black',
    font_size=10,
    bbox=dict(facecolor='white', alpha=0.7, edgecolor='none', pad=0.5)
)

plt.show()


