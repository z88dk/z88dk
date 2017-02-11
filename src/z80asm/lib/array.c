/*
Z88DK Z80 Macro Assembler

Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "array.h"

DEF_ARRAY(Byte);
DEF_ARRAY(Word);
DEF_ARRAY(int);
DEF_ARRAY(long);
