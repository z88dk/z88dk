//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2020
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#pragma once

#include <stdbool.h>

bool assemble_file(const char* input_filename);
void syntax_error(void);
void illegal_opcode_error(void);
void range_error(int n);
void invalid_number_error(void);
void missing_quote_error(void);
void reserved_warning(const char* word);
