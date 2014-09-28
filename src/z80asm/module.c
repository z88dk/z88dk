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

Copyright (C) Paulo Custodio, 2011-2014

Assembled module, i.e. result of assembling a .asm file

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/module.c,v 1.16 2014-09-28 17:37:14 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

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
DEFINE_init()
{
	/* setup module list */
	g_module_list = OBJ_NEW( ModuleList );
}

DEFINE_fini()
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

	init();
	module = OBJ_NEW( Module );
	ModuleList_push( &g_module_list, module );
	return module;
}

void delete_modules( void )
{
	init();
	g_cur_module = NULL;
	ModuleList_remove_all( g_module_list );
}

/*-----------------------------------------------------------------------------
*   current module
*----------------------------------------------------------------------------*/
Module *set_cur_module( Module *module )
{
	init();
	set_cur_module_id( module->module_id );
	set_cur_section( get_first_section(NULL) );
	return (g_cur_module = module);		/* result result of assignment */
}

Module *get_cur_module( void )
{
	init();
	return g_cur_module;
}

/*-----------------------------------------------------------------------------
*   list of modules iterator
*	pointer to iterator may be NULL if no need to iterate
*----------------------------------------------------------------------------*/
Module *get_first_module( ModuleListElem **piter )
{
	ModuleListElem *iter;

	init();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = ModuleList_first( g_module_list );
	return *piter == NULL ? NULL : (Module *) (*piter)->obj;
}

Module *get_last_module( ModuleListElem **piter )
{
	ModuleListElem *iter;

	init();
	if ( piter == NULL )
		piter = &iter;		/* user does not need to iterate */

	*piter = ModuleList_last( g_module_list );
	return *piter == NULL ? NULL : (Module *) (*piter)->obj;
}

Module *get_next_module( ModuleListElem **piter )
{
	init();
	*piter = ModuleList_next( *piter );
	return *piter == NULL ? NULL : (Module *) (*piter)->obj;
}
