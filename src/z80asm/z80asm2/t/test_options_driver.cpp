#include "test.h"
#include "xassert.h"
#include "../options.h"
#include <string>
using namespace std;

void test_exit_copyright();
void test_exit_help();
int exec_exit_copyright();
int exec_exit_help();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        if (arg == "exec_exit_copyright")
            return exec_exit_copyright();
        if (arg == "exec_exit_help")
            return exec_exit_help();
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_exit_copyright();
        test_exit_help();
    }

    done_testing();
}
