#include "test.h"
#include "xassert.h"
#include "../utils.h"
#include <string>
using namespace std;

void test_str_chomp();
void test_str_strip();
void test_remove_extra_blanks();
void test_remove_all_blanks();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_str_chomp();
        test_str_strip();
        test_remove_extra_blanks();
        test_remove_all_blanks();
    }

    done_testing();
}
