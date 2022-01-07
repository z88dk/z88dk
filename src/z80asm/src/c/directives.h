/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Assembly directives.
*/

#pragma once

#include "str.h"
#include "utarray.h"

struct Expr;

enum {
	DEFVARS_SIZE_B = 1,
	DEFVARS_SIZE_W = 2,
	DEFVARS_SIZE_P = 3,
	DEFVARS_SIZE_Q = 4,
};

/* define a label at the current location, or current location + offset */
extern void asm_LABEL(const char* name);
extern void asm_LABEL_offset(const char* name, int offset);
extern void asm_cond_LABEL(Str* label);		// define label if not empty

/* start a new DEFVARS context, closing any previously open one */
extern void asm_DEFVARS_start(int start_addr);

/* define one constant in the current context */
extern void asm_DEFVARS_define_const(const char* name, int elem_size, int count);

/* start a new DEFGROUP context, give the value of the next defined constant */
extern void asm_DEFGROUP_start(int next_value);

/* define one constant with the next value, increment the value */
extern void asm_DEFGROUP_define_const(const char* name);

/* directives without arguments */
extern void asm_LSTON(void);
extern void asm_LSTOFF(void);

extern void asm_LINE(int line_num, const char* filename);
extern void asm_C_LINE(int line_num, const char* filename);
extern void asm_ORG(int address);
extern void asm_PHASE(int address);
extern void asm_DEPHASE();

/* directives with name argument */
extern void asm_MODULE(const char* name);
extern void asm_SECTION(const char* name);

/* define default module name, if none defined by asm_MODULE() */
extern void asm_MODULE_default(void);

/* directives with list of names argument, function called for each argument */
extern void asm_GLOBAL(const char* name);
extern void asm_EXTERN(const char* name);
extern void asm_XREF(const char* name);
extern void asm_LIB(const char* name);
extern void asm_PUBLIC(const char* name);
extern void asm_XDEF(const char* name);
extern void asm_XLIB(const char* name);
extern void asm_DEFINE(const char* name);
extern void asm_UNDEFINE(const char* name);

/* define a constant or expression */
extern void asm_DEFC(const char* name, struct Expr* expr);

/* create a block of empty bytes, called by the DEFS directive */
extern void asm_DEFS(int count, int fill);
extern void asm_DEFS_str(int count, const char* str, int len);

/* DEFB - add an expression or a string */
extern void asm_DEFB_str(const char* str, int length);
extern void asm_DEFB_expr(struct Expr* expr);

/* 24-bit pointers */
extern void asm_DEFP(struct Expr* expr);
extern void asm_PTR(struct Expr* expr);
extern void asm_DP(struct Expr* expr);

/* DEFW, DEFQ, DEFDB - add 2-byte and 4-byte expressions */
extern void asm_DEFW(struct Expr* expr);
extern void asm_WORD(struct Expr* expr);
extern void asm_DW(struct Expr* expr);

extern void asm_DEFDB(struct Expr* expr);	// big-endian word
extern void asm_DDB(struct Expr* expr);		// big-endian word

extern void asm_DEFQ(struct Expr* expr);
extern void asm_DWORD(struct Expr* expr);
extern void asm_DQ(struct Expr* expr);

/* align directive */
extern void asm_ALIGN(int align, int filler);

/* Z80 DMA commands */
extern void asm_DMA_command(int cmd, UT_array* exprs);	// stack of exprs, top is last
