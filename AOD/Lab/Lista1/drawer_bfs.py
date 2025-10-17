import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt



filename = "/home/wojteq18/sem5/AOD/Lab/Lista1/zadanie1/bfs/bfs_tree.txt"
df = pd.read_csv(filename, sep=" ", names=["parent", "child", "order"])
G = nx.DiGraph()
for _, row in df.iterrows():
    G.add_edge(row["parent"], row["child"], order=row.get("order", None))

root = min(G.nodes)

levels = dict(nx.single_source_shortest_path_length(G, root))
nx.set_node_attributes(G, levels, "subset")

pos = nx.multipartite_layout(G, subset_key="subset")

plt.figure(figsize=(10, 6))
nx.draw(
    G, pos,
    with_labels=True,
    node_size=800, node_color="lightblue", font_size=9, arrows=False
)

edge_labels = nx.get_edge_attributes(G, "order")
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_color="red")

plt.title("Drzewo BFS z kolejnością odwiedzin", fontsize=14)
plt.show()