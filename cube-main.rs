use std::arch::global_asm;
use std::env;
use std::str;
global_asm!(include_str!("cube.s"));

extern {
    fn cube(xx: i64) -> i64;
}

fn main() {
	let args: Vec<String> = std::env::args().collect();
	let argc = args.len();
	
	if argc != 2 {
		println!("Usage: ./cube N");
	}
	
	let xx: i64 = args[1].parse().expect("Not a valid number");
	let mut yy: i64;
	unsafe { yy = cube(xx); };
	println!("result = {}\n", yy);
}
