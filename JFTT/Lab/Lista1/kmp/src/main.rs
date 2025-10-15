use std::env;
use std::fs;
use std::process;

fn compute_prefix_function(pattern: &str) -> Vec<usize> {
    let m = pattern.len();
    let mut pi = vec![0; m];
    let mut k = 0;
    for q in 1..m {
        while k > 0 && pattern.as_bytes()[k] != pattern.as_bytes()[q] {
            k = pi[k - 1];
        }

        if pattern.as_bytes()[k] == pattern.as_bytes()[q] {
            k += 1;
        }
        pi[q] = k;
    }
    return pi
}

fn kmp_matcher(text: &str, pattern: &str) {
    let n = text.len();
    let m = pattern.len();
    let pi = compute_prefix_function(pattern);
    let mut q = 0;
    for i in 0..n {
        while q > 0 && pattern.as_bytes()[q] != text.as_bytes()[i] {
            q = pi[q - 1];
        }

        if pattern.as_bytes()[q] == text.as_bytes()[i] {
            q += 1;
        }

        if q == m {
            println!("Pattern occurs with shift {}", i + 1 - m);
            q = pi[q - 1];
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
    
    kmp_matcher(&text, pattern);
}

