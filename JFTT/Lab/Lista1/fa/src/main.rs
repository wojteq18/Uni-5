use std::env;
use std::fs;
use std::process;


fn compute_transition_function(pattern: &str) -> Vec<Vec<usize>> {
    let m = pattern.len();
    let alphabet_size = 256;
    let mut delta = vec![vec![0; alphabet_size]; m + 1]; //mamy m+1 stanów, 256 możliwych znaków w ascii
    let pattern_bytes = pattern.as_bytes();

    for q in 0..=m {
        for a in 0..alphabet_size {
            let line_prefix = &pattern_bytes[0..q];
            let mut k = std::cmp::min(m, q + 1);

            loop {
                if k == 0 {
                    break;
                }

                let pattern_prefix_k = &pattern_bytes[0..k];
                if pattern_prefix_k[0..k-1] == line_prefix[q-(k-1)..] && pattern_prefix_k[k-1] == a as u8 { //sprawdzamy czy prefiks długości k-1 jest sufiksem długości q i czy kończy się na a
                    break;
                }
                k -= 1; //zmniejszamy k dopóki nie znajdziemy prefiksu który jest sufiksem i kończy się na a
            }
            delta[q][a] = k;
        }
    }
    return delta;
} 

fn finite_automation_matcher(text: &str, delta: &Vec<Vec<usize>>, m: usize) {
    let n = text.len();
    let mut q = 0;

    for i in 0..n {
        q = delta[q][text.as_bytes()[i] as usize];
        if q == m {
            let start_index = i + 1 - m;
            println!("Pattern occurs with shift {}", start_index);
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        eprintln!("Usage: {} <pattern> <text_file>", args[0]);
        process::exit(1);
    }

    let pattern = &args[1];
    let filename = &args[2];

    let text = fs::read_to_string(filename).expect("Could not read file");
    
    let delta = compute_transition_function(pattern);
    finite_automation_matcher(&text, &delta, pattern.len());
}
