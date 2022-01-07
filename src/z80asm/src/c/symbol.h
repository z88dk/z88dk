/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#pragma once

#include "expr.h"
#include "zobjfile.h"
#include "symtab.h"
#include "types.h"
#include "scan.h"
#include <stdlib.h>

/* Structured data types : */

enum flag           { OFF, ON };
