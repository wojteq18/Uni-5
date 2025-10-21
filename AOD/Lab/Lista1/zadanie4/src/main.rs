use std::collections::VecDeque;
use std::io::BufReader;
use std::fs::File;
use std::error::Error;
use std::io::BufRead;

fn bfs(vert_number: &usize,adj_list: &Vec<Vec<usize>>, source: usize) -> (Vec<usize>, Vec<usize>, Vec<usize>) {
    let mut fifo_queue: VecDeque<usize> = VecDeque::new();
    let mut colors: Vec<usize> = vec![0; *vert_number + 1]; //o -> white, 1 -> gray, 2 -> black
    let mut distance: Vec<i16> = vec![-1; *vert_number + 1]; //-1 means infinity
    let mut parents: Vec<isize> = vec![-1; *vert_number + 1]; //-1 means null
    let mut visit_order: Vec<usize> = Vec::new(); //to store the order of visits
    let mut number: Vec<usize> = vec![2; *vert_number + 1]; 

    colors[source] = 1; //gray
    distance[source] = 0;
    number[source] = 0;

    let mut vec_0 = Vec::new();
    let mut vec_1 = Vec::new();

    fifo_queue.push_back(source);

    while let Some(u) = fifo_queue.pop_front() {
        visit_order.push(u);
        for v in &adj_list[u] {
            if number[*v] == 2 {
                number[*v] = (number[u] + 1) % 2;
            } else if number[*v] == number[u] {
                println!("Graph is not bipartite");
                return (vec![], vec![], vec![]);
            } 
            if colors[*v] == 0 {
                colors[*v] = 1; //gray
                distance[*v] = distance[u] + 1;
                parents[*v] = u as isize;
                fifo_queue.push_back(*v);

                if number[*v] == 0 {
                    vec_0.push(*v);
                } else if number[*v] == 1 {
                    vec_1.push(*v);
                }
            }
        }
        colors[u] = 2; //black
    }
    return (vec_0, vec_1, colors);
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
    let (mut vec_0, mut vec_1, colors) = bfs(&num_vex, &adj_list, 1);

    for u in 1..=num_vex {
        if colors[u] == 0 {
            let (vec00, vec11, _colors) = bfs(&num_vex, &adj_list, u);
            vec_0.append(&mut vec00.clone());
            vec_1.append(&mut vec11.clone());
        }
    }

    if num_vex <= 200 {
        let vec_0_str: Vec<String> = vec_0.iter().map(|&n| n.to_string()).collect();
        let vec_1_str: Vec<String> = vec_1.iter().map(|&n| n.to_string()).collect();
        println!("Set 0: {}", vec_0_str.join(", "));
        println!("Set 1: {}", vec_1_str.join(", "));
    }
}