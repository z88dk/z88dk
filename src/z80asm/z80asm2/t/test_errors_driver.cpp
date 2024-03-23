#include "test.h"
#include "xassert.h"
#include "../errors.h"
#include <string>
using namespace std;

void test_error_message();
void test_error_message_with_string_arg();
void test_error_message_with_numeric_arg();
void test_error_message_with_invalid_err_code();
void test_count_of_errors();
void test_warning_message();
void test_warning_message_with_string_arg();
void test_warning_message_with_numeric_arg();
void test_count_of_warnings();
int exec_error_message_with_invalid_err_code1();
int exec_error_message_with_invalid_err_code2();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        if (arg == "exec_error_message_with_invalid_err_code1")
            return exec_error_message_with_invalid_err_code1();
        if (arg == "exec_error_message_with_invalid_err_code2")
            return exec_error_message_with_invalid_err_code2();
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_error_message();
        test_error_message_with_string_arg();
        test_error_message_with_numeric_arg();
        test_error_message_with_invalid_err_code();
        test_count_of_errors();
        test_warning_message();
        test_warning_message_with_string_arg();
        test_warning_message_with_numeric_arg();
        test_count_of_warnings();
    }

    done_testing();
}
