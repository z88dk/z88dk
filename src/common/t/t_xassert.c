//-----------------------------------------------------------------------------
// assertion that is not removed in a release compile
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "xassert.h"

void run_die_xassert(void)
{
    xassert(1);
    xassert(0);
}

