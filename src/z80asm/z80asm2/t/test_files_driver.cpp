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
    }

    done_testing();
}
