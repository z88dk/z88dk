#ifndef IXSAVE_TESTS_H
#define IXSAVE_TESTS_H

#include <string.h>
#include <stdio.h>
#include "test.h"

/* Returns the current value of IX (ixsave_asm.asm) */
extern unsigned ix_get(void);

extern int test_memop();

#endif
