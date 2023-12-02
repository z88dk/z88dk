//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "die.h"
#include "types.h"
#include <memory.h>

void run_die_die(void)
{
	die("hello %s %d!\n", "world", 42);
}

