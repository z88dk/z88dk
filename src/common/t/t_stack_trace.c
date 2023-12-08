//-----------------------------------------------------------------------------
// stack_trace - show a stack dump on SIGSEGV in Linux
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "stack_trace.h"
#include <memory.h>

void run_stack_trace_on_sigsegv(void)
{
    dump_stack_on_sigsegv();

#ifdef TEST_STACK_DUMP  // stack dump has always different addresses, test cannot run normally
    int* p = (int*)0;
    *p = 123;           // SIGSEGV
#endif
}
