//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#pragma once

#include <stdbool.h>

bool assemble_file(const char* input_filename);
void error_syntax(void);
void error_illegal(void);
void error_range(int n);
