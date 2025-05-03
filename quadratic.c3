
module quadratic;
import std::io;
import std::math;



struct QuadraticResult {
    int num_zeros;
    double x1;
    double x2;
}

fn QuadraticResult solve_quadratic(double a, double b, double c) {
    QuadraticResult result;
    double disc = b * b - 4.0 * a * c;
    if (disc < 0.0) {
        result.num_zeros = 0;
        return result;
    }
    double sqrt_disc = math::sqrt(disc);
    double x1 = (-b + sqrt_disc) / (2.0 * a);
    double x2 = (-b - sqrt_disc) / (2.0 * a);
    if (x1 == x2) {
        result.num_zeros = 1;
        result.x1 = x1;
        result.x2 = x1;
    } else {
        result.num_zeros = 2;
        result.x1 = x1;
        result.x2 = x2;
    }
    return result;
}

fn void main(String[] args) {
    if (args.len == 2 && args[1] == "--test") {
        io::printn("Running tests...");
        test_quadratic();
        io::printn("All tests passed.");
        return;
    }
    if (args.len < 4) {
        io::printn("Usage: quadratic <a> <b> <c> | --test");
        return;
    }
    double? a = args[1].to_double();
    double? b = args[2].to_double();
    double? c = args[3].to_double();
    if (catch err = a) {
        io::printn("Invalid value for a");
        return;
    }
    if (catch err = b) {
        io::printn("Invalid value for b");
        return;
    }
    if (catch err = c) {
        io::printn("Invalid value for c");
        return;
    }
    QuadraticResult res = solve_quadratic(a, b, c);
    if (res.num_zeros == 0) {
        io::printn("No real zeros");
    } else if (res.num_zeros == 1) {
        io::printfn("One real zero: %f", res.x1);
    } else {
        io::printfn("Two real zeros: %f and %f", res.x1, res.x2);
    }
}

// --- Tests ---
fn void test_quadratic() {
    QuadraticResult r;
    // Two real zeros: x^2 - 3x + 2 = 0 => x=1, x=2
    r = solve_quadratic(1.0, -3.0, 2.0);
    assert(r.num_zeros == 2);
    assert((r.x1 == 2.0 && r.x2 == 1.0) || (r.x1 == 1.0 && r.x2 == 2.0));

    // One real zero: x^2 + 2x + 1 = 0 => x=-1
    r = solve_quadratic(1.0, 2.0, 1.0);
    assert(r.num_zeros == 1);
    assert(r.x1 == -1.0);

    // No real zeros: x^2 + 1 = 0
    r = solve_quadratic(1.0, 0.0, 1.0);
    assert(r.num_zeros == 0);
}
