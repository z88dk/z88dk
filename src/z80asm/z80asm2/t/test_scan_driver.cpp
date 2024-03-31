#include "test.h"
#include "xassert.h"
#include "../scan.h"
#include <string>
using namespace std;

void test_keyword_lookup();
void test_lexer_empty();
void test_lexer_symbols();
void test_lexer_ident();
void test_lexer_uppercase();
void test_lexer_swap_ixiy();
void test_lexer_integer();
void test_lexer_bitmap();
void test_lexer_floating();
void test_lexer_string();
void test_lexer_file_string();
void test_lexer_invalid_char();
void test_lexer_invalid_double_quoted_string();
void test_lexer_invalid_single_quoted_string();
void test_lexer_invalid_character_constant1();
void test_lexer_invalid_character_constant2();
void test_character_constant();
void test_lexer_assume();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_keyword_lookup();
        test_lexer_empty();
        test_lexer_symbols();
        test_lexer_ident();
        test_lexer_uppercase();
        test_lexer_swap_ixiy();
        test_lexer_integer();
        test_lexer_bitmap();
        test_lexer_floating();
        test_lexer_string();
        test_lexer_file_string();
        test_lexer_invalid_char();
        test_lexer_invalid_double_quoted_string();
        test_lexer_invalid_single_quoted_string();
        test_lexer_invalid_character_constant1();
        test_lexer_invalid_character_constant2();
        test_character_constant();
        test_lexer_assume();
    }

    done_testing();
}
