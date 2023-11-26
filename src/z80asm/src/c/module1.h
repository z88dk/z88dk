/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Assembled module, i.e. result of assembling a .asm file
*/

#pragma once

#include "class.h"
#include "classhash.h"
#include "classlist.h"
#include "codearea.h"
#include "expr1.h"
#include "objfile.h"
#include "symtab1.h"
#include "types.h"
#include "z80asm_defs.h"

/*-----------------------------------------------------------------------------
*   Assembly module
*----------------------------------------------------------------------------*/
CLASS( Module1 )
	const char	*modname;			/* module name, kept in strpool */
	const char	*filename;			/* source file name, kept in strpool */
	int			 module_id;			/* sequence number of linked modules in sections */
    Expr1List	*exprs;				/* list of expressions */
	Symbol1Hash	*local_symtab;		/* module local symbols */

	objfile_t	*objfile;
END_CLASS;

CLASS_LIST( Module1 );

/* new modules set codearea module_id and default (=first) section */
extern Module1 *new_module( void );

extern void delete_modules( void );

/* set current module, set codearea module_id and default (=first) section */
extern Module1 *set_cur_module( Module1 *module ); /* return input to allow chaining */

extern Module1 *get_cur_module( void );

#define CURRENTMODULE	(get_cur_module())

/* list of modules iterator, pointer to iterator may be NULL if no need to iterate */
extern Module1 *get_first_module( Module1ListElem **piter );
extern Module1 *get_last_module(  Module1ListElem **piter );
extern Module1 *get_next_module(  Module1ListElem **piter );
