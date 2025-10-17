def get_graph_info(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        graph_type = lines[0].strip()
        num_vertex = int(lines[1].strip())
    return graph_type, num_vertex, lines


def parse_graph_from_file(file_path):
    graph_type, num_vertex, lines = get_graph_info(file_path)

    adjacency_list = {i: [] for i in range(1, num_vertex + 1)}

    if graph_type == 'U': # Undirected graph
        for line in lines[3:]:
            parts = line.strip().split()
            if len(parts) == 2:
                u, v = int(parts[0]), int(parts[1])
                adjacency_list[u].append(v)
                adjacency_list[v].append(u)

    else:  # Directed graph
        for line in lines[3:]:
            parts = line.strip().split()
            if len(parts) == 2:
                u, v = int(parts[0]), int(parts[1])
                adjacency_list[u].append(v)

    return adjacency_list, num_vertex    


if __name__ == "__main__":
    print("Type a graph file: ")
    path = input().strip()
    graph, num_vertex = parse_graph_from_file(path)

    with open('graph_for_rust.txt', 'w') as f:
        f.write(f"{num_vertex}\n")
        
        for i in range(1, num_vertex + 1):
            neighbors_str = ' '.join(map(str, graph[i]))
            f.write(f"{neighbors_str}\n")
            
