#include "test.h"
#include "xassert.h"
#include "../expr.h"
#include <string>
using namespace std;

void test_empty_expr_result();
void test_ok_expr_result();
void test_error_expr_result();
void test_empty_expr();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_empty_expr_result();
        test_ok_expr_result();
        test_error_expr_result();
        test_empty_expr();
    }

    done_testing();
}
