use clap::{Parser, ArgGroup, ValueEnum}; //parser -> zeby struktura mogla przyjmowac #[derive(Parser)], ArgGroup -> zeby grupowac argumenty
use std::path::PathBuf; //do przechowywania sciezek do plikow


#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord, ValueEnum, Debug)]
enum AlgorithmVariant {
    Dijkstra,
    Dial,
    Radix
}

#[derive(Parser, Debug,)] 
#[command(group(
    ArgGroup::new("mode_ss")
    .args(["ss_path", "oss_path"])
    .multiple(true)
    .conflicts_with("mode_p2p")
))]
#[command(group(
    ArgGroup::new("mode_p2p")
        .args(["p2p_path", "op2p_path"])
        .multiple(true)
        .conflicts_with("mode_ss")
))]

struct Args {
    #[arg(short = 'd', help = "Path to the graph file")]
    graph_path: PathBuf,

    #[arg(long = "ss", help = "File with source and sink nodes")]
    ss_path: Option<PathBuf>,

    #[arg(long = "oss", help = "Exec file for ss")]
    oss_path: Option<PathBuf>,

    #[arg(long = "p2p", help = "File with point-to-point nodes")]
    p2p_path: Option<PathBuf>,

    #[arg(long = "op2p", help = "Exec file for p2p")]
    op2p_path: Option<PathBuf>,

    #[arg(short = 'a', help = "Algorithm to use")]
    algorithm: AlgorithmVariant,
}

#[derive(Debug, Eq, PartialEq)]
struct Edge {
    target: usize,
    weight: i32,
}

#[derive(Debug, Eq, PartialEq)]
struct Graph {
    adjacency_list: Vec<Vec<Edge>>,
}

fn dijkstra_algorithm(graph_file: &PathBuf, source: usize) { 

}

fn main() {
    let args = Args::parse();
}
