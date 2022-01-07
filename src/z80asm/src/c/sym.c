/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

One symbol from the assembly code - label or constant.
*/

#include "options.h"
#include "str.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"
#include "utstring.h"

/*-----------------------------------------------------------------------------
*   Constant tables
*----------------------------------------------------------------------------*/
char *sym_type_str[] = {
	"undef",
	"const",
	"addr",
	"comput",
};

char *sym_scope_str[] = {
	"local",
	"public",
	"extern",
	"global",
};

/*-----------------------------------------------------------------------------
*   Symbol
*----------------------------------------------------------------------------*/
DEF_CLASS( Symbol )

void Symbol_init( Symbol *self ) {}
void Symbol_copy( Symbol *self, Symbol *other ) {}
void Symbol_fini( Symbol *self ) {}

/*-----------------------------------------------------------------------------
*   create a new symbol, needs to be deleted by OBJ_DELETE()
*	adds a reference to the page were referred to
*----------------------------------------------------------------------------*/
Symbol *Symbol_create(const char *name, long value, sym_type_t type, sym_scope_t scope,
					   Module *module, Section *section )
{
    Symbol *self 	= OBJ_NEW( Symbol );

	self->name = spool_add(name);			/* name in strpool, not freed */
	self->value = value;
	self->type = type;
	self->scope = scope;
	self->module = module;
	self->section = section;
	self->filename = get_error_filename();
	self->line_num = get_error_line_num();

    return self;              						/* pointer to new symbol */
}

/*-----------------------------------------------------------------------------
*   return full symbol name NAME@MODULE stored in strpool
*----------------------------------------------------------------------------*/
const char *Symbol_fullname( Symbol *sym )
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
