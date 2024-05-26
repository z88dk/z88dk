//-----------------------------------------------------------------------------
// z80asm - global data
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "assembler.h"

// program name
#define Z80ASM_PROG	    "z88dk-z80asm"

// environment variables
#define Z80ASM_ENVVAR	"Z80ASM"
#define ZCC_ENVVAR      "ZCCCFG"

// library base name
#define Z80ASM_LIB_BASE	Z80ASM_PROG

// application class
extern Assembler g_asm;

// shortcuts
inline Options& g_options() { return g_asm.options(); }
inline Errors& g_errors() { return g_asm.errors(); }
inline Module& g_module() { return g_asm.object().cur_module(); }
inline Section& g_section() { return g_module().cur_section(); }
inline Symtab& g_symtab() { return g_module().symtab(); }
