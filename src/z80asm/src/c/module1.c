/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Assembled module, i.e. result of assembling a .asm file
*/

#include "codearea.h"
#include "init.h"
#include "module1.h"

/*-----------------------------------------------------------------------------
*   Global data
*----------------------------------------------------------------------------*/
static Module1List		*g_module_list;			/* list of input modules */
static Module1			*g_cur_module;			/* current module being handled */

/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
	/* setup module list */
	g_module_list = OBJ_NEW( Module1List );
}

DEFINE_dtor_module()
{
	OBJ_DELETE( g_module_list );
}

/*-----------------------------------------------------------------------------
*   Assembly module
*----------------------------------------------------------------------------*/
DEF_CLASS( Module1 );
DEF_CLASS_LIST( Module1 );

void Module1_init (Module1 *self)   
{
	self->module_id	= new_module_id();

	self->local_symtab	= OBJ_NEW( Symbol1Hash );
	OBJ_AUTODELETE( self->local_symtab ) = false;

	self->exprs			= OBJ_NEW( Expr1List );
	OBJ_AUTODELETE( self->exprs ) = false;

	self->objfile = objfile_new();
}

void Module1_copy (Module1 *self, Module1 *other)	
{ 
	self->exprs = Expr1List_clone( other->exprs ); 
	self->local_symtab = Symbol1Hash_clone( other->local_symtab );
}

void Module1_fini (Module1 *self)
{ 
	OBJ_DELETE( self->exprs);
	OBJ_DELETE( self->local_symtab );

	objfile_free(self->objfile);
}

/*-----------------------------------------------------------------------------
*   new and delete modules
*----------------------------------------------------------------------------*/
Module1 *new_module( void )
{
	Module1 *module;

	init_module();
	module = OBJ_NEW( Module1 );
	Module1List_push( &g_module_list, module );

	return module;
}

void delete_modules( void )
{
	init_module();
	g_cur_module = NULL;
	Module1List_remove_all( g_module_list );
}

/*-----------------------------------------------------------------------------
*   current module
*----------------------------------------------------------------------------*/
Module1 *set_cur_module( Module1 *module )
{
	init_module();
	set_cur_module_id( module->module_id );
	set_cur_section( get_first_section(NULL) );
	return (g_cur_module = module);		/* result result of assignment */
}

Module1 *get_cur_module( void )
{
	init_module();
	return g_cur_module;
}

/*-----------------------------------------------------------------------------
*   list of modules iterator
*	pointer to iterator may be NULL if no need to iterate
*----------------------------------------------------------------------------*/
Module1 *get_first_module( Module1ListElem **piter )
{
	Module1ListElem *iter;

	init_module();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = Module1List_first( g_module_list );
	return *piter == NULL ? NULL : (Module1 *) (*piter)->obj;
}

Module1 *get_last_module( Module1ListElem **piter )
{
	Module1ListElem *iter;

	init_module();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = Module1List_last( g_module_list );
	return *piter == NULL ? NULL : (Module1 *) (*piter)->obj;
}

Module1 *get_next_module( Module1ListElem **piter )
{
	init_module();
	*piter = Module1List_next( *piter );
	return *piter == NULL ? NULL : (Module1 *) (*piter)->obj;
}
