unsafe extern "C" {
    fn cube(xx: i64) -> i64;
}

fn main() {
	let args: Vec<String> = std::env::args().collect();
	let argc = args.len();
	
	if argc != 2 {
		println!("Usage: ./cube N");
		std::process::exit(-1);
	}
	
	let xx: i64 = args[1].parse().expect("Not a valid number");
	let yy: i64;
	unsafe { yy = cube(xx); };
	println!("result = {}", yy);
}
