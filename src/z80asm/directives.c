/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Assembly directives.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/directives.c,v 1.10 2015-01-21 23:34:54 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include to enable memory leak detection */

#include "codearea.h"
#include "directives.h"
#include "errors.h"
#include "fileutil.h"
#include "model.h"
#include "module.h"
#include "parse.h"
#include "strpool.h"
#include "types.h"
#include "symtab.h"
#include <assert.h>

/*-----------------------------------------------------------------------------
*   LABEL: define a label at the current location
*----------------------------------------------------------------------------*/
void asm_LABEL_offset(char *name, int offset)
{
	define_symbol(name, get_PC() + offset, TYPE_ADDRESS, SYM_TOUCHED);
}

void asm_LABEL(char *name)
{
	asm_LABEL_offset(name, 0);
}

/*-----------------------------------------------------------------------------
*   DEFGROUP
*----------------------------------------------------------------------------*/

static int DEFGROUP_PC;			/* next value to assign */

/* start a new DEFGROUP context, give the value of the next defined constant */
void asm_DEFGROUP_start(int next_value)
{
	DEFGROUP_PC = next_value;
}

/* define one constant with the next value, increment the value */
void asm_DEFGROUP_define_const(char *name)
{
	assert(name != NULL);
	
	if (DEFGROUP_PC > 0xFFFF || DEFGROUP_PC < -0x8000)
		error_int_range(DEFGROUP_PC);
	else 
		define_symbol(name, DEFGROUP_PC, TYPE_CONSTANT, 0);
	DEFGROUP_PC++;
}

/*-----------------------------------------------------------------------------
*   DEFS
*----------------------------------------------------------------------------*/

/* create a block of empty bytes, called by the DEFS directive */
void asm_DEFS(int count, int fill)
{
	if (count < 0 || count > 0x10000)
		error_int_range(count);
	else if (fill < -128 || fill > 255)
		error_int_range(fill);
	else
		append_defs(count, fill);
}

/*-----------------------------------------------------------------------------
*   DEFVARS
*----------------------------------------------------------------------------*/

static int DEFVARS_GLOBAL_PC;	/* DEFVARS address counter for global structs
								*  created by a chain of DEFVARS -1 */
static int DEFVARS_STRUCT_PC;	/* DEFVARS address counter for zero based structs
								*  restared on each DEFVARS 0 */
static int *DEFVARS_PC = &DEFVARS_STRUCT_PC;	/* select current DEFVARS PC*/

/* start a new DEFVARS context, closing any previously open one */
void asm_DEFVARS_start(int start_addr)
{
	if (start_addr == -1)
		DEFVARS_PC = &DEFVARS_GLOBAL_PC;	/* continue from previous DEFVARS_GLOBAL_PC */
	else if (start_addr == 0)
	{
		DEFVARS_PC = &DEFVARS_STRUCT_PC;	/* start a new struct context */
		DEFVARS_STRUCT_PC = 0;
	}
	else if (start_addr > 0 && start_addr <= 0xFFFF)
	{
		DEFVARS_PC = &DEFVARS_GLOBAL_PC;	/* start a new DEFVARS_GLOBAL_PC */
		DEFVARS_GLOBAL_PC = start_addr;
	}
	else
		error_int_range(start_addr);
}

/* define one constant in the current context */
void asm_DEFVARS_define_const(char *name, int elem_size, int count)
{
	int var_size = elem_size * count;
	int next_pc = *DEFVARS_PC + var_size;

	assert(name != NULL);

	if (var_size > 0xFFFF)
		error_int_range(var_size);
	else if (next_pc > 0xFFFF)
		error_int_range(next_pc);
	else
	{
		define_symbol(name, *DEFVARS_PC, TYPE_CONSTANT, 0);
		*DEFVARS_PC = next_pc;
	}
}

/*-----------------------------------------------------------------------------
*   directives without arguments
*----------------------------------------------------------------------------*/
void asm_LSTON(void)
{
	if (opts.list)
		opts.cur_list = TRUE;
}

void asm_LSTOFF(void)
{
	if (opts.list)
		opts.cur_list = FALSE;
}

/*-----------------------------------------------------------------------------
*   directives with number argument
*----------------------------------------------------------------------------*/
void asm_LINE(int line_nr)
{
	DEFINE_STR(name, MAXLINE);

	if (opts.line_mode)
		set_error_line(line_nr);

	Str_sprintf(name, "__C_LINE_%ld", line_nr);
	asm_LABEL(name->str);
}

void asm_ORG(int address)
{
	set_origin_directive(address);
}

/*-----------------------------------------------------------------------------
*   directives with string argument 
*----------------------------------------------------------------------------*/
void asm_INCLUDE(char *filename)
{
	parse_file(filename);
}

void asm_BINARY(char *filename)
{
	FILE *binfile;

	filename = search_file(filename, opts.inc_path);

	binfile = xfopen(filename, "rb");		/* CH_0012 */
	append_file_contents(binfile, -1);		/* read binary code */
	xfclose(binfile);
}

/*-----------------------------------------------------------------------------
*   directives with name argument
*----------------------------------------------------------------------------*/
void asm_MODULE(char *name)
{
	if (CURRENTMODULE->modname)
		error_module_redefined();
	else
	{
		CURRENTMODULE->modname = strpool_add(name);

		if (opts.force_xlib)
			declare_public_symbol(name);
	}
}

void asm_MODULE_default(void)
{
	if (!CURRENTMODULE->modname)     /* Module name must be defined */
		CURRENTMODULE->modname = path_remove_ext(path_basename(CURRENTMODULE->filename));
}

void asm_SECTION(char *name)
{
	new_section(name);
}

/*-----------------------------------------------------------------------------
*   directives with list of names argument, function called for each argument
*----------------------------------------------------------------------------*/
void asm_EXTERN(char *name)
{
	declare_extern_symbol(name);
}

void asm_XREF(char *name)
{
	warn_deprecated("XREF", "EXTERN");
	declare_extern_symbol(name);
}

void asm_LIB(char *name)
{
	warn_deprecated("LIB", "EXTERN");
	declare_extern_symbol(name);
}

void asm_PUBLIC(char *name)
{
	declare_public_symbol(name);
}

void asm_XDEF(char *name)
{
	warn_deprecated("XDEF", "PUBLIC"); 
	declare_public_symbol(name);
}

void asm_XLIB(char *name)
{
	warn_deprecated("XLIB", "PUBLIC"); 
	declare_public_symbol(name);
}
