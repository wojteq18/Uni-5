import pandas as pd
import networkx as nx
import sys
import matplotlib.pyplot as plt

filename = "/home/wojteq18/sem5/AOD/Lab/Lista1/zadanie1/dfs/dfs_tree.txt"
df = pd.read_csv(filename, sep=" ", names=["parent", "child", "order"])
G = nx.DiGraph()
for _, row in df.iterrows():
    G.add_edge(row["parent"], row["child"], order=row.get("order", None))

# Pozycjonowanie wierzchołków (spring layout dla DFS)
pos = nx.spring_layout(G, seed=42)

plt.figure(figsize=(10, 6))
nx.draw(
    G, pos,
    with_labels=True,
    node_size=800, node_color="lightgreen", font_size=9, arrows=True
)

edge_labels = nx.get_edge_attributes(G, "order")
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_color="blue")

plt.title("Drzewo DFS z kolejnością odwiedzin", fontsize=14)
plt.show()