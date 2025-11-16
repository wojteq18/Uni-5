import random
import networkx as nx
import matplotlib.pyplot as plt

def generate_random_graph(num_nodes, num_edges, max_weight=15):

    if num_nodes <= 0:
        return nx.DiGraph()
        
    G = nx.DiGraph()
    # Wierzchołki są numerowane od 1 do num_nodes
    nodes = range(1, num_nodes + 1)
    G.add_nodes_from(nodes)

    edge_count = 0
    # Pętla generuje krawędzie, aż osiągnięta zostanie docelowa liczba
    # lub gdy dodanie nowej, unikalnej krawędzi jest mało prawdopodobne.
    max_attempts = num_edges * 5 
    attempts = 0
    while edge_count < num_edges and attempts < max_attempts:
        u, v = random.sample(nodes, 2)
        
        # Unikamy tworzenia wielokrotnych krawędzi między tymi samymi wierzchołkami
        if not G.has_edge(u, v):
            cost = random.randint(1, max_weight)
            time = random.randint(1, max_weight)
            G.add_edge(u, v, cost=cost, time=time)
            edge_count += 1
        attempts += 1
        
    return G

def get_graph_text_representation(graph):

    edges_str = []
    # Sortujemy krawędzie dla spójnego wyjścia
    sorted_edges = sorted(graph.edges(data=True), key=lambda x: (x[0], x[1]))

    for u, v, data in sorted_edges:
        edges_str.append(f"({u}, {v}, {data['cost']}, {data['time']})")
    
    return ", ".join(edges_str) + "."

def draw_graph(graph):

    pos = nx.spring_layout(graph, seed=42)  # Użycie seeda zapewnia powtarzalność układu
    plt.figure(figsize=(12, 8))
    
    nx.draw(graph, pos, with_labels=True, node_color='lightblue', node_size=500, font_size=10, arrows=True)
    
    edge_labels = {(u, v): f"{d['cost']},{d['time']}" for u, v, d in graph.edges(data=True)}
    nx.draw_networkx_edge_labels(graph, pos, edge_labels=edge_labels, font_color='red')
    
    plt.title("Wygenerowany Graf")
    plt.show()

if __name__ == '__main__':
    # Ustawienia dla generowanego grafu
    NUM_NODES = 12  # Podobna liczba wierzchołków jak w przykładzie
    NUM_EDGES = 25  # Podobna liczba krawędzi jak w przykładzie

    # Generowanie grafu
    random_graph = generate_random_graph(NUM_NODES, NUM_EDGES)

    # Wyświetlanie tekstowej reprezentacji
    text_representation = get_graph_text_representation(random_graph)
    print("Tekstowa reprezentacja wygenerowanego grafu:")
    print(text_representation)

    # Rysowanie grafu
    draw_graph(random_graph)