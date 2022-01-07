/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

One symbol from the assembly code - label or constant.
*/

#pragma once

#include "class.h"
#include "types.h"

struct Module;
struct Section;

/*-----------------------------------------------------------------------------
*   Special symbols
*----------------------------------------------------------------------------*/
#define ASMHEAD_KW	"__%s%s" "head"
#define ASMTAIL_KW	"__%s%s" "tail"
#define ASMSIZE_KW	"__%s%s" "size"

/*-----------------------------------------------------------------------------
*   Type of symbol
*	Expressions have the type of the greatest symbol used
*----------------------------------------------------------------------------*/
typedef enum {
	TYPE_UNKNOWN,						/* symbol not defined */
	TYPE_CONSTANT,						/* can be computed */
	TYPE_ADDRESS,						/* depends on ASMPC, can be computed after
										   address allocation */
	TYPE_COMPUTED,						/* depends on the result of an expression
										   that has this symbol as target */
} sym_type_t;

extern char *sym_type_str[];

/*-----------------------------------------------------------------------------
*   Scope of symbol
*	Initially defined as LOCAL
*----------------------------------------------------------------------------*/
typedef enum {
	SCOPE_LOCAL,
	SCOPE_PUBLIC,						/* defined and exported */
	SCOPE_EXTERN,						/* not defined and imported */
	SCOPE_GLOBAL,						/* PUBLIC if defined, EXTERN if not defined */
} sym_scope_t;

extern char *sym_scope_str[];

/*-----------------------------------------------------------------------------
*   Symbol
*----------------------------------------------------------------------------*/
CLASS( Symbol )
	const char	   *name;				/* name, kept in strpool */
	long			value;				/* computed value of symbol */
	sym_type_t		type;				/* type of symbol */
	sym_scope_t		scope;				/* scope of symbol definition */
	bool			is_computed : 1;	/* true if TYPE_COMPUTED or TYPE_ADDRESS 
										 * and value already known */
	bool			is_defined : 1;		/* true if symbol was defined in the current module */
	bool			is_touched : 1;		/* true if symbol was used, e.g. returned by 
										 * a symbol table search */
	bool			is_global_def : 1;	/* true for __head, __tail, __size symbols */
	struct Module  *module;				/* module which owns symbol (weak ref) */
	struct Section *section;			/* section where expression is defined (weak ref) */
	const char	   *filename;			/* file where defined */
	int				line_num;			/* line where defined */
END_CLASS;

/*-----------------------------------------------------------------------------
*   Symbol API
*----------------------------------------------------------------------------*/

/* create a new symbol, needs to be deleted by OBJ_DELETE()
   adds a reference to the page were referred to */
extern Symbol *Symbol_create(const char *name, long value, sym_type_t type, sym_scope_t scope,
							  struct Module *module, struct Section *section );

/* return full symbol name NAME@MODULE stored in strpool */
extern const char *Symbol_fullname( Symbol *sym );
