// Redefine the GMP struct and alias for test file
struct MpzStruct {
    int _mp_alloc;
    int _mp_size;
    ulong* _mp_d;
}
alias MpzArray = MpzStruct[1];
module gmp_example_test;
import std::io;
// import gmp_example; // Not needed, we use FFI directly

struct TestCase {
    ulong n;
    char* expected;
}

TestCase[] test_cases = {
    {0, "1"},
    {1, "1"},
    {2, "2"},
    {5, "120"},
    {10, "3628800"},
    {20, "2432902008176640000"},
};

extern fn void __gmpz_init(MpzStruct* x);
extern fn void __gmpz_clear(MpzStruct* x);
extern fn void __gmpz_set_ui(MpzStruct* rop, ulong op);
extern fn void __gmpz_mul_ui(MpzStruct* rop, MpzStruct* op1, ulong op2);
extern fn void __gmpz_get_str(char* str, int base, MpzStruct* op);

fn bool gmp_factorial_to_str(ulong n, char* outbuf, int outbuflen) {
    MpzArray result = {};
    __gmpz_init(&result[0]);
    __gmpz_set_ui(&result[0], 1);
    for (ulong i = 2; i <= n; i++) {
        __gmpz_mul_ui(&result[0], &result[0], i);
    }
    __gmpz_get_str(outbuf, 10, &result[0]);
    __gmpz_clear(&result[0]);
    // Check for null terminator
    for (int i = 0; i < outbuflen; i++) {
        if (outbuf[i] == 0) return true;
    }
    return false;
}

fn void main() {
    char[128] buf;
    bool all_passed = true;
    for (int i = 0; i < test_cases.len; i++) {
        TestCase t = test_cases[i];
        for (int j = 0; j < 128; j++) buf[j] = 0;
        bool ok = gmp_factorial_to_str(t.n, &buf[0], 128);
        if (!ok) {
            io::print("Test failed for n = ");
            io::printn(t.n);
            io::printn(": output not null-terminated");
            all_passed = false;
            continue;
        }
        // Compare result
        int k = 0;
        bool match = true;
        while (t.expected[k] != 0 && buf[k] != 0) {
            if (t.expected[k] != buf[k]) {
                match = false;
                break;
            }
            k++;
        }
        if (t.expected[k] != 0 || buf[k] != 0) match = false;
        if (!match) {
            io::print("Test failed for n = ");
            io::printn(t.n);
            io::print(": expected ");
            io::printn(t.expected);
            io::print(", got ");
            for (int m = 0; buf[m] != 0; m++) io::print(buf[m]);
            io::printn("");
            all_passed = false;
        } else {
            io::print("Test passed for n = ");
            io::printn(t.n);
        }
    }
    if (all_passed) {
        io::printn("All tests passed.");
    } else {
        io::printn("Some tests failed.");
    }
}
