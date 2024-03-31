#include "test.h"
#include "xassert.h"
#include "../utils.h"
#include <string>
using namespace std;

void test_is_ident_start();
void test_is_ident_char();
void test_is_ident_str();
void test_char_digit();
void test_str_ends_with();
void test_str_tolower();
void test_str_toupper();
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
        test_is_ident_start();
        test_is_ident_char();
        test_is_ident_str();
        test_char_digit();
        test_str_ends_with();
        test_str_tolower();
        test_str_toupper();
        test_str_chomp();
        test_str_strip();
        test_remove_extra_blanks();
        test_remove_all_blanks();
    }

    done_testing();
}
