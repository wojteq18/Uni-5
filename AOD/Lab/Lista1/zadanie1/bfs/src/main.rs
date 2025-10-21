use std::collections::VecDeque;
use std::io::BufReader;
use std::fs::File;
use std::error::Error;
use std::io::BufRead;
use std::io::Write;
use std::env;
use std::process;
use std::time::Instant; 


fn bfs(vert_number: &usize,adj_list: &Vec<Vec<usize>>, source: usize, tree: bool) {
    let mut fifo_queue: VecDeque<usize> = VecDeque::new();
    let mut colors: Vec<usize> = vec![0; *vert_number + 1]; //o -> white, 1 -> gray, 2 -> black
    let mut distance: Vec<i16> = vec![-1; *vert_number + 1]; //-1 means infinity
    let mut parents: Vec<isize> = vec![-1; *vert_number + 1]; //-1 means null
    let mut visit_order: Vec<usize> = Vec::new(); //to store the order of visits

    colors[source] = 1; //gray
    distance[source] = 0;

    fifo_queue.push_back(source);

    while let Some(u) = fifo_queue.pop_front() {
        visit_order.push(u);
        for v in &adj_list[u] {
            if colors[*v] == 0 {
                colors[*v] = 1; //gray
                distance[*v] = distance[u] + 1;
                parents[*v] = u as isize;
                fifo_queue.push_back(*v);
            }
        }
        colors[u] = 2; //black
    }

    let order_str: Vec<String> = visit_order.iter().map(|&n| n.to_string()).collect();
    println!("order of visits: {}", order_str.join(" -> "));

    if tree == true {
        let mut file = File::create("bfs_tree.txt").expect("Impossible to create file");
        for v in 1..= *vert_number {
            if parents[v] != -1 {
                writeln!(file, "{} {} {}", parents[v], v, distance[v]).expect("Błąd zapisu.");
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
    let start = Instant::now();
    bfs(&num_vex, &adj_list, 1, tree == "Y");
    let duration = start.elapsed();
    println!("Time elapsed in bfs() is: {:?}", duration);
}
