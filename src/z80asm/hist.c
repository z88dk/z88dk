/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "hist.h"
#ifdef _MSC_VER
#include "../../win32/config.h"
#else
#include "../config.h"
#endif

#ifndef Z88DK_VERSION
#define Z88DK_VERSION "build " __DATE__
#endif

#define COPYRIGHT   "InterLogic 1993-2009, Paulo Custodio 2011-2017"

char copyrightmsg[] = "Z80 Module Assembler " Z88DK_VERSION "\n(c) " COPYRIGHT;
