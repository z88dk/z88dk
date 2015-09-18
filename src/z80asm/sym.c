/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

One symbol from the assembly code - label or constant.
*/

#include "listfile.h"
#include "options.h"
#include "strpool.h"
#include "str.h"
#include "sym.h"
#include "symbol.h"

/*-----------------------------------------------------------------------------
*   Symbol
*----------------------------------------------------------------------------*/
DEF_CLASS( Symbol )

void Symbol_init( Symbol *self )
{
    self->references = OBJ_NEW( SymbolRefList );
    OBJ_AUTODELETE( self->references ) = FALSE;
}

void Symbol_copy( Symbol *self, Symbol *other )
{
    self->references = SymbolRefList_clone( other->references );
}

void Symbol_fini( Symbol *self )
{
    OBJ_DELETE( self->references );
}

/*-----------------------------------------------------------------------------
*   create a new symbol, needs to be deleted by OBJ_DELETE()
*	adds a reference to the page were referred to
*----------------------------------------------------------------------------*/
Symbol *Symbol_create(char *name, long value, sym_type_t type, sym_scope_t scope,
					   Module *module, Section *section )
{
    Symbol *self 	= OBJ_NEW( Symbol );

	self->name = strpool_add(name);			/* name in strpool, not freed */
	self->value = value;
	self->type = type;
	self->scope = scope;
	self->module = module;
	self->section = section;

    /* add reference */
    add_symbol_ref( self->references, list_get_page_nr(), FALSE );

    return self;              						/* pointer to new symbol */
}

/*-----------------------------------------------------------------------------
*   return full symbol name NAME@MODULE stored in strpool
*----------------------------------------------------------------------------*/
char *Symbol_fullname( Symbol *sym )
{
	STR_DEFINE(name, STR_SIZE);
	char *ret;

    str_set( name, sym->name );

    if ( sym->module && sym->module->modname )
    {
        str_append_char( name, '@' );
        str_append( name, sym->module->modname );
    }

    ret = strpool_add( str_data(name) );

	STR_DELETE(name);

	return ret;
}
