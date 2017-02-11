/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Assembled module, i.e. result of assembling a .asm file
*/

#include "codearea.h"
#include "init.h"
#include "module.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Global data
*----------------------------------------------------------------------------*/
static ModuleList		*g_module_list;			/* list of input modules */
static Module			*g_cur_module;			/* current module being handled */

/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
	/* setup module list */
	g_module_list = OBJ_NEW( ModuleList );
}

DEFINE_dtor_module()
{
	OBJ_DELETE( g_module_list );
}

/*-----------------------------------------------------------------------------
*   Assembly module
*----------------------------------------------------------------------------*/
DEF_CLASS( Module );
DEF_CLASS_LIST( Module );

void Module_init (Module *self)   
{
	self->module_id	= new_module_id();

	self->local_symtab	= OBJ_NEW( SymbolHash );
	OBJ_AUTODELETE( self->local_symtab ) = FALSE;

	self->exprs			= OBJ_NEW( ExprList );
	OBJ_AUTODELETE( self->exprs ) = FALSE;
}

void Module_copy (Module *self, Module *other)	
{ 
	self->exprs = ExprList_clone( other->exprs ); 
	self->local_symtab = SymbolHash_clone( other->local_symtab );
}

void Module_fini (Module *self)
{ 
	OBJ_DELETE( self->exprs);
	OBJ_DELETE( self->local_symtab );
}

/*-----------------------------------------------------------------------------
*   new and delete modules
*----------------------------------------------------------------------------*/
Module *new_module( void )
{
	Module *module;

	init_module();
	module = OBJ_NEW( Module );
	ModuleList_push( &g_module_list, module );
	return module;
}

void delete_modules( void )
{
	init_module();
	g_cur_module = NULL;
	ModuleList_remove_all( g_module_list );
}

/*-----------------------------------------------------------------------------
*   current module
*----------------------------------------------------------------------------*/
Module *set_cur_module( Module *module )
{
	init_module();
	set_cur_module_id( module->module_id );
	set_cur_section( get_first_section(NULL) );
	return (g_cur_module = module);		/* result result of assignment */
}

Module *get_cur_module( void )
{
	init_module();
	return g_cur_module;
}

/*-----------------------------------------------------------------------------
*   list of modules iterator
*	pointer to iterator may be NULL if no need to iterate
*----------------------------------------------------------------------------*/
Module *get_first_module( ModuleListElem **piter )
{
	ModuleListElem *iter;

	init_module();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = ModuleList_first( g_module_list );
	return *piter == NULL ? NULL : (Module *) (*piter)->obj;
}

Module *get_last_module( ModuleListElem **piter )
{
	ModuleListElem *iter;

	init_module();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = ModuleList_last( g_module_list );
	return *piter == NULL ? NULL : (Module *) (*piter)->obj;
}

Module *get_next_module( ModuleListElem **piter )
{
	init_module();
	*piter = ModuleList_next( *piter );
	return *piter == NULL ? NULL : (Module *) (*piter)->obj;
}
