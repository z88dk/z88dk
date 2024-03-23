#include "test.h"
#include "xassert.h"
#include "../location.h"
#include <string>
using namespace std;

void test_empty_location();
void test_location_with_filename();
void test_location_with_filename_line_num();
void test_location_with_filename_line_num_c_file();
void test_clear();
void test_set_filename();
void test_set_line();
void test_set_line_filename();
void test_set_c_line();
void test_set_c_line_filename();
void test_inc_line_num();
void test_inc_c_line_num();
void test_to_string_empty();
void test_to_string_filename();
void test_to_string_filename_line_num();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_empty_location();
        test_location_with_filename();
        test_location_with_filename_line_num();
        test_location_with_filename_line_num_c_file();
        test_clear();
        test_set_filename();
        test_set_line();
        test_set_line_filename();
        test_set_c_line();
        test_set_c_line_filename();
        test_inc_line_num();
        test_inc_c_line_num();
        test_to_string_empty();
        test_to_string_filename();
        test_to_string_filename_line_num();
    }

    done_testing();
}
