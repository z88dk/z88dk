#include "test.h"
#include "xassert.h"
#include "../options.h"
#include <string>
using namespace std;


int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
    }

    done_testing();
}
