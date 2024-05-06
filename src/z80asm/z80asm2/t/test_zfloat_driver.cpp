#include "test.h"
#include "xassert.h"
#include "../zfloat.h"
#include <string>
using namespace std;

void test_float_to_bytes();
void test_float_expr();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_float_to_bytes();
        test_float_expr();
    }

    done_testing();
}
