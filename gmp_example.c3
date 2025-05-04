module gmp_example;
import std::io;

// C3 FFI for GMP
// Use the actual GMP struct definition for mpz_t compatibility
struct MpzStruct {
    int _mp_alloc;
    int _mp_size;
    ulong* _mp_d;
}
alias MpzArray = MpzStruct[1];

extern fn void __gmpz_init(MpzStruct* x);
extern fn void __gmpz_clear(MpzStruct* x);
extern fn void __gmpz_set_ui(MpzStruct* rop, ulong op);
extern fn void __gmpz_mul_ui(MpzStruct* rop, MpzStruct* op1, ulong op2);
extern fn void __gmpz_get_str(char* str, int base, MpzStruct* op);

fn void gmp_factorial(ulong n) {
    MpzArray result = {};
    __gmpz_init(&result[0]);
    // Always start with 1 and multiply up
    __gmpz_set_ui(&result[0], 1);
    for (ulong i = 2; i <= n; i++) {
        __gmpz_mul_ui(&result[0], &result[0], i);
    }
    char[1024] buffer;
    for (int i = 0; i < 1024; i++) buffer[i] = 0;
    __gmpz_get_str(&buffer[0], 10, &result[0]);
    io::printn("Factorial:");
    io::print(n);
    io::print("! = ");
    // Print as string, character by character
    // Print as string: find length, then print as char[] slice
    int len = 0;
    while (buffer[len] != 0 && len < 1024) len++;
    // Print as string, character by character
    for (int i = 0; i < len; i++) {
        io::printf("%c", buffer[i]);
    }
    io::printn("");
    __gmpz_clear(&result[0]);
}

//
// Build/run instructions:
//   c3c compile gmp.c3 -lgmp
//   LD_LIBRARY_PATH=. c3c compile-run gmp.c3 -lgmp
//
fn void main(String[] args) {
    if (args.len < 2) {
        io::printn("Usage: gmp <n>");
        return;
    }
    ulong? n = args[1].to_ulong();
    if (catch err = n) {
        io::printn("Invalid value for n");
        return;
    }
    gmp_factorial(n);
}
