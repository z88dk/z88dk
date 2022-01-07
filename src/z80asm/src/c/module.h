/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Assembled module, i.e. result of assembling a .asm file
*/

#pragma once

#include "class.h"
#include "classlist.h"
#include "classhash.h"
#include "codearea.h"
#include "expr.h"
#include "symtab.h"
#include "types.h"

#include "objfile.h"

/*-----------------------------------------------------------------------------
*   Assembly module
*----------------------------------------------------------------------------*/
CLASS( Module )
	const char	*modname;			/* module name, kept in strpool */
	const char	*filename;			/* source file name, kept in strpool */
	int			 module_id;			/* sequence number of linked modules in sections */
    ExprList	*exprs;				/* list of expressions */
	SymbolHash	*local_symtab;		/* module local symbols */

	objfile_t	*objfile;
END_CLASS;

CLASS_LIST( Module );

/* new modules set codearea module_id and default (=first) section */
extern Module *new_module( void );

extern void delete_modules( void );

/* set current module, set codearea module_id and default (=first) section */
extern Module *set_cur_module( Module *module ); /* return input to allow chaining */

extern Module *get_cur_module( void );

#define CURRENTMODULE	(get_cur_module())

/* list of modules iterator, pointer to iterator may be NULL if no need to iterate */
extern Module *get_first_module( ModuleListElem **piter );
extern Module *get_last_module(  ModuleListElem **piter );
extern Module *get_next_module(  ModuleListElem **piter );
