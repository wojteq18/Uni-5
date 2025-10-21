use std::io::BufReader;
use std::fs::File;
use std::error::Error;
use std::io::BufRead;


fn dfs_visit(
    color: &mut Vec<usize>,
    adj_list: &Vec<Vec<usize>>,
    u: usize, 
    parent: &mut Vec<usize>,
    order: &mut Vec<usize>,
) {
    color[u] = 1; // Gray

    for v in &adj_list[u] {
        if color[*v] == 0 { 
            parent[*v] = u;
            dfs_visit(color, adj_list, *v, parent, order);
        }
    }
    color[u] = 2; // Black
    order.push(u);
    }

fn dfs(num_vertex: &usize, adj_list: &Vec<Vec<usize>>) -> Vec<usize> {
    let mut color: Vec<usize> = vec![0; num_vertex + 1]; // 0:white, 1:gray, 2:black
    let mut parent: Vec<usize> = vec![0; num_vertex + 1]; // 0 means no parent
    let mut order: Vec<usize> = Vec::with_capacity(*num_vertex);


    for u in 1..=*num_vertex {
        if color[u] == 0 { 
            dfs_visit(&mut color, adj_list, u, &mut parent, &mut order);
        }
    }
    return order;
}

fn dfs_for_t(num_vertex: &usize, adj_list: &Vec<Vec<usize>>, order: &Vec<usize>) -> Vec<Vec<usize>> {
    let mut color: Vec<usize> = vec![0; num_vertex + 1]; // 0:white, 1:gray, 2:black
    let mut scc_list: Vec<Vec<usize>> = Vec::new();

    for &u in order {
        if color[u] == 0 { 
            let mut scc = Vec::new();
            collect_scc(u, adj_list, &mut color, &mut scc);
            scc_list.push(scc);
        }
    }
    return scc_list;
}

fn collect_scc(
    u: usize,
    adj_list: &Vec<Vec<usize>>,
    color: &mut Vec<usize>,
    scc: &mut Vec<usize>,
) {
    color[u] = 1;
    scc.push(u);
    for &v in &adj_list[u] {
        if color[v] == 0 {
            collect_scc(v, adj_list, color, scc);
        }
    }
    color[u] = 2;
}

fn parse_simple_format(file_path: &str) -> Result<(usize, Vec<Vec<usize>>), Box<dyn Error>> {
    let file = File::open(file_path)?;
    let mut reader = BufReader::new(file);

    let mut num_vertex_str = String::new();
    reader.read_line(&mut num_vertex_str)?;
    let num_vertex = num_vertex_str.trim().parse::<usize>()?;

    let mut adj_list: Vec<Vec<usize>> = vec![vec![]; num_vertex + 1];

    for vertex_id in 1..=num_vertex {
        let mut line = String::new();
        reader.read_line(&mut line)?;
        
        let neighbors: Vec<usize> = line
            .split_whitespace() 
            .map(|s| s.parse().expect("Błąd parsowania numeru sąsiada"))
            .collect();
        
        adj_list[vertex_id] = neighbors;
    }

    Ok((num_vertex, adj_list))
}

fn transpose_graph(adj_list: &Vec<Vec<usize>>, num_vertex: usize) -> Vec<Vec<usize>> {
    let mut adj_list_t: Vec<Vec<usize>> = vec![vec![]; num_vertex + 1];

    for u in 1..=num_vertex {
        for &v in &adj_list[u] {
            adj_list_t[v].push(u); // Reverse the direction of the edge: u -> v becomes v -> u
        }
    }

    return adj_list_t
}



fn main() {
    let (num_vex, adj_list) = parse_simple_format("/home/wojteq18/sem5/AOD/Lab/Lista1/graph_for_rust.txt").unwrap();
    let mut order = dfs(&num_vex, &adj_list);
    order.sort();
    order.reverse();
    let adj_list_t = transpose_graph(&adj_list, num_vex);
    let scc_list = dfs_for_t(&num_vex, &adj_list_t, &order);

    println!("Number of SCCs: {}", scc_list.len());

    if num_vex <= 200 {
        for (i, scc) in scc_list.iter().enumerate() {
            println!("SCC {}: {:?}", i + 1, scc);
        }
    }    
}