use std::io::BufReader;
use std::fs::File;
use std::error::Error;
use std::io::BufRead;
use std::io::Write;


fn dfs_visit(
    color: &mut Vec<usize>,
    adj_list: &Vec<Vec<usize>>,
    u: usize, 
    parent: &mut Vec<usize>,
    order: &mut Vec<usize>,
) -> bool {
    color[u] = 1; // Gray

    for v in &adj_list[u] {
        if color[*v] == 0 { 
            parent[*v] = u;
            if !dfs_visit(color, adj_list, *v, parent, order) {
                return false;
            }
        } else if color[*v] == 1 {
            // Found a back edge, indicating a cycle
            return false;
        }
    }
    color[u] = 2; // Black
    order.push(u);
    return true
    }

fn dfs_top(num_vertex: usize, adj_list: &Vec<Vec<usize>>) {
    let mut color: Vec<usize> = vec![0; num_vertex + 1]; // 0:white, 1:gray, 2:black
    let mut parent: Vec<usize> = vec![0; num_vertex + 1]; // 0 means no parent
    let mut order: Vec<usize> = Vec::with_capacity(num_vertex); //vec to store topological order


    for u in 1..=num_vertex {
        if color[u] == 0 { 
            if !dfs_visit(&mut color, adj_list, u, &mut parent, &mut order) {
                println!("Graph contains a cycle. Topological sorting not possible.");
                return;
            }
        }
    }

    order.reverse(); // Reverse to get the correct topological order
    println!("Graph is a DAG");

    if num_vertex <= 200 {
        let mut file = File::create("topological.txt").expect("Impossible to create file");
        for v in order.iter() {
            writeln!(file, "{}", v).expect("Impossible to write to file");
        }
    }    
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


fn main() {
    let (num_vex, adj_list) = parse_simple_format("/home/wojteq18/sem5/AOD/Lab/Lista1/graph_for_rust.txt").unwrap();
    dfs_top(num_vex, &adj_list);
}