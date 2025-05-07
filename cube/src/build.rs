fn main() {
    cc::Build::new()
        .file("src/cube.s")
        .compile("my-asm-lib");
}
