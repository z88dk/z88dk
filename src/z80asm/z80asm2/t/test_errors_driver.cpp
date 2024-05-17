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
void test_errors_exit_code();
void test_warning_message();
void test_warning_message_with_string_arg();
void test_warning_message_with_numeric_arg();
void test_count_of_warnings();
void test_error_at_location1();
void test_error_at_location2();
void test_error_at_location3();
void test_error_at_location4();
void test_error_at_location5();
void test_error_at_location6();
void test_error_at_location7();
void test_error_at_location8();
void test_error_at_location9();
void test_error_at_location10();
void test_error_with_source_text1();
void test_error_with_source_text2();
void test_error_with_source_text3();
void test_error_with_source_text4();
void test_error_with_source_text5();
void test_error_with_source_text6();
void test_error_with_source_text7();
void test_error_with_expanded_text1();
void test_error_with_expanded_text2();
void test_error_with_expanded_text3();
void test_error_with_expanded_text4();
void test_error_with_expanded_text5();
void test_error_with_expanded_text6();
void test_error_with_expanded_text7();
void test_error_with_expanded_text8();
void test_error_push_location();
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
        test_errors_exit_code();
        test_warning_message();
        test_warning_message_with_string_arg();
        test_warning_message_with_numeric_arg();
        test_count_of_warnings();
        test_error_at_location1();
        test_error_at_location2();
        test_error_at_location3();
        test_error_at_location4();
        test_error_at_location5();
        test_error_at_location6();
        test_error_at_location7();
        test_error_at_location8();
        test_error_at_location9();
        test_error_at_location10();
        test_error_with_source_text1();
        test_error_with_source_text2();
        test_error_with_source_text3();
        test_error_with_source_text4();
        test_error_with_source_text5();
        test_error_with_source_text6();
        test_error_with_source_text7();
        test_error_with_expanded_text1();
        test_error_with_expanded_text2();
        test_error_with_expanded_text3();
        test_error_with_expanded_text4();
        test_error_with_expanded_text5();
        test_error_with_expanded_text6();
        test_error_with_expanded_text7();
        test_error_with_expanded_text8();
        test_error_push_location();
    }

    done_testing();
}
