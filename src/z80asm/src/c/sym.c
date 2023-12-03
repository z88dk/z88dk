/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

One symbol from the assembly code - label or constant.
*/

#include "expr1.h"
#include "if.h"
#include "scan1.h"
#include "str.h"
#include "strpool.h"
#include "strutil.h"
#include "sym.h"
#include "symtab1.h"
#include "types.h"
#include "utstring.h"
#include "zobjfile.h"

/*-----------------------------------------------------------------------------
*   Symbol1
*----------------------------------------------------------------------------*/
DEF_CLASS( Symbol1 )

void Symbol1_init( Symbol1 *self ) {}
void Symbol1_copy( Symbol1 *self, Symbol1 *other ) {}
void Symbol1_fini( Symbol1 *self ) {}

/*-----------------------------------------------------------------------------
*   create a new symbol, needs to be deleted by OBJ_DELETE()
*	adds a reference to the page were referred to
*----------------------------------------------------------------------------*/
Symbol1 *Symbol_create(const char *name, long value, sym_type_t type, sym_scope_t scope,
					   Module1 *module, Section1 *section )
{
    Symbol1 *self 	= OBJ_NEW( Symbol1 );

	self->name = spool_add(name);			/* name in strpool, not freed */
	self->value = value;
	self->scope = scope;
	self->type = type;
	self->module = module;
	self->section = section;
	self->filename = get_error_filename();
	self->line_num = get_error_line_num();

    return self;              						/* pointer to new symbol */
}

/*-----------------------------------------------------------------------------
*   return full symbol name NAME@MODULE stored in strpool
*----------------------------------------------------------------------------*/
const char *Symbol_fullname( Symbol1 *sym )
{
	STR_DEFINE(name, STR_SIZE);
	const char *ret;

    Str_set( name, sym->name );

    if ( sym->module && sym->module->modname )
    {
        Str_append_char( name, '@' );
        Str_append( name, sym->module->modname );
    }

    ret = spool_add( Str_data(name) );

	STR_DELETE(name);

	return ret;
}
