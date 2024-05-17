#include "test.h"
#include "xassert.h"
#include "../symtab.h"
#include <string>
using namespace std;

void test_symtab_define_symbol_command_line_1();
void test_symtab_define_symbol_command_line_10();
void test_symtab_define_symbol_command_line_duplicate_equal();
void test_symtab_define_symbol_command_line_duplicate_different();
void test_symtab_define_symbol_command_and_source_equ();
void test_symtab_define_symbol_command_and_source_label();
void test_symtab_define_symbol_command_and_source_public_use();
void test_symtab_define_symbol_command_and_source_global_use();
void test_symtab_define_symbol_command_and_source_extern_use();
void test_symtab_define_symbol();
void test_symtab_define_undefine();
void test_symtab_define_undefine_define();
void test_symtab_define_and_equ();
void test_symtab_define_and_label();
void test_symtab_define_and_define();
void test_symtab_define_and_public();
void test_symtab_public_and_define();
void test_symtab_define_and_global();
void test_symtab_global_and_define();
void test_symtab_define_and_extern();
void test_symtab_extern_and_define();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_symtab_define_symbol_command_line_1();
        test_symtab_define_symbol_command_line_10();
        test_symtab_define_symbol_command_line_duplicate_equal();
        test_symtab_define_symbol_command_line_duplicate_different();
        test_symtab_define_symbol_command_and_source_equ();
        test_symtab_define_symbol_command_and_source_label();
        test_symtab_define_symbol_command_and_source_public_use();
        test_symtab_define_symbol_command_and_source_global_use();
        test_symtab_define_symbol_command_and_source_extern_use();
        test_symtab_define_symbol();
        test_symtab_define_undefine();
        test_symtab_define_undefine_define();
        test_symtab_define_and_equ();
        test_symtab_define_and_label();
        test_symtab_define_and_define();
        test_symtab_define_and_public();
        test_symtab_public_and_define();
        test_symtab_define_and_global();
        test_symtab_global_and_define();
        test_symtab_define_and_extern();
        test_symtab_extern_and_define();
    }

    done_testing();
}
