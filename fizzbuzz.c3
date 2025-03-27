module fizzbuzz;
import std::io;

fn void fizzbuzz(int n) {
    for (int i = 1; i <= n; i++) {
        if (i % 3 == 0 && i % 5 == 0) {
            io::printn("FizzBuzz");
        } else if (i % 3 == 0) {
            io::printn("Fizz");
        } else if (i % 5 == 0) {
            io::printn("Buzz");
        } else {
            io::printfn("%d", i);
        }
    }
}

fn void main() {
    fizzbuzz(100);
}