

#include "stdlib_tests.h"

// qsort_newlib.c #asm-INCLUDEs the newlib sort cores (asm_quicksort etc.) as
// PUBLIC symbols.  Those would shadow the classic library's shared sort core in
// the main test binary, so this suite lives in its own binary (test_newlib.bin).

int main(int argc, char *argv[])
{
    int  res = 0;

#ifndef __8080
  #ifndef __GBZ80
    res += test_qsort_newlib();
  #endif
#endif

    return res;
}
