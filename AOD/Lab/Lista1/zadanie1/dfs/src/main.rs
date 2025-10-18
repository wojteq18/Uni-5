use std::io::BufReader;
use std::fs::File;
use std::error::Error;
use std::io::BufRead;
use std::io::Write;
use std::env;
use std::process;


fn dfs_visit(
    color: &mut Vec<usize>,
    adj_list: &Vec<Vec<usize>>,
    u: usize, 
    parent: &mut Vec<usize>,
    order: &mut usize,
) {
    color[u] = 1; // Gray

    for v in &adj_list[u] {
        if color[*v] == 0 { 
            *order += 1;
            parent[*v] = u;
            dfs_visit(color, adj_list, *v, parent, order);
        }
    }
    color[u] = 2; // Black
    }

fn dfs(num_vertex: &usize, adj_list: &Vec<Vec<usize>>, print_tree: &bool) {
    let mut color: Vec<usize> = vec![0; num_vertex + 1]; // 0:white, 1:gray, 2:black
    let mut parent: Vec<usize> = vec![0; num_vertex + 1]; // 0 means no parent
    let mut order: usize = 0; // Edge discovery order counter


    for u in 1..=*num_vertex {
        if color[u] == 0 { 
            dfs_visit(&mut color, adj_list, u, &mut parent, &mut order);
        }
    }

    if *print_tree {
        let mut file = File::create("dfs_tree.txt").expect("Impossible to create file");
        let mut temp_order = 0;
        for v in 1..=*num_vertex {
            if parent[v] != 0 { // If vertex 'v' has a parent
                temp_order += 1;
                writeln!(file, "{} {} {}", parent[v], v, temp_order).expect("Impossible to write to file");
            }
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
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <Y or N>", args[0]);
        process::exit(1);
    }
    let tree = &args[1];
    let (num_vex, adj_list) = parse_simple_format("/home/wojteq18/sem5/AOD/Lab/Lista1/graph_for_rust.txt").unwrap();
    dfs(&num_vex, &adj_list, &(tree == "Y"));
}
