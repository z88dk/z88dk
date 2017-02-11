/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Assembly directives.
*/

#pragma once

struct Expr;

enum {
	DEFVARS_SIZE_B = 1,
	DEFVARS_SIZE_W = 2,
	DEFVARS_SIZE_P = 3,
	DEFVARS_SIZE_Q = 4,
};

/* define a label at the current location, or current location + offset */
extern void asm_LABEL(char *name);
extern void asm_LABEL_offset(char *name, int offset);

/* start a new DEFVARS context, closing any previously open one */
extern void asm_DEFVARS_start(int start_addr);

/* define one constant in the current context */
extern void asm_DEFVARS_define_const(char *name, int elem_size, int count);

/* start a new DEFGROUP context, give the value of the next defined constant */
extern void asm_DEFGROUP_start(int next_value);

/* define one constant with the next value, increment the value */
extern void asm_DEFGROUP_define_const(char *name);

/* directives without arguments */
extern void asm_LSTON(void);
extern void asm_LSTOFF(void);

/* directives with number argument */
extern void asm_LINE(int line_nr);
extern void asm_ORG(int address);

/* directives with string argument */
extern void asm_INCLUDE(char *filename);
extern void asm_BINARY(char *filename);

/* directives with name argument */
extern void asm_MODULE(char *name);
extern void asm_SECTION(char *name);

/* define default module name, if none defined by asm_MODULE() */
extern void asm_MODULE_default(void);

/* directives with list of names argument, function called for each argument */
extern void asm_GLOBAL(char *name);
extern void asm_EXTERN(char *name);
extern void asm_PUBLIC(char *name);
extern void asm_DEFINE(char *name);
extern void asm_UNDEFINE(char *name);

/* define a constant or expression */
extern void asm_DEFC(char *name, struct Expr *expr);

/* create a block of empty bytes, called by the DEFS directive */
extern void asm_DEFS(int count, int fill);

/* DEFB - add an expression or a string */
extern void asm_DEFB_str(char *str, int length);
extern void asm_DEFB_expr(struct Expr *expr);

/* DEFW, DEFQ - add 2-byte and 4-byte expressions */
extern void asm_DEFW(struct Expr *expr);
extern void asm_DEFQ(struct Expr *expr);
