#include "test.h"
#include "xassert.h"
#include "../ofiles.h"
#include <string>
using namespace std;

void test_simplest_file();
void test_changed_cpu();
void test_add_1_byte_of_code();
void test_define_org();
void test_add_expression();
void test_add_defc_and_extern();
void test_add_label();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_simplest_file();
        test_changed_cpu();
        test_add_1_byte_of_code();
        test_define_org();
        test_add_expression();
        test_add_defc_and_extern();
        test_add_label();
    }

    done_testing();
}
