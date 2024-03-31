#include "test.h"
#include "xassert.h"
#include "../files.h"
#include <string>
using namespace std;

void test_search_path();
void test_open_file_non_existent();
void test_open_file_ok();
void test_file_reader_non_existent();
void test_file_reader_recursive();
void test_file_reader_ok();
void test_source_reader_ok();
void test_file_basename();
void test_file_replace_extension();
void test_file_prepend_output_dir();
void test_file_parent_dir();
void test_file_is_regular_file();
void test_file_is_directory();
void test_file_create_directories();
void test_file_asm_filename();
void test_file_lis_filename();
void test_file_o_filename();
void test_file_def_filename();
void test_file_bin_filename();
void test_file_lib_filename();
void test_file_sym_filename();
void test_file_map_filename();
void test_file_reloc_filename();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_search_path();
        test_open_file_non_existent();
        test_open_file_ok();
        test_file_reader_non_existent();
        test_file_reader_recursive();
        test_file_reader_ok();
        test_source_reader_ok();
        test_file_basename();
        test_file_replace_extension();
        test_file_prepend_output_dir();
        test_file_parent_dir();
        test_file_is_regular_file();
        test_file_is_directory();
        test_file_create_directories();
        test_file_asm_filename();
        test_file_lis_filename();
        test_file_o_filename();
        test_file_def_filename();
        test_file_bin_filename();
        test_file_lib_filename();
        test_file_sym_filename();
        test_file_map_filename();
        test_file_reloc_filename();
    }

    done_testing();
}
