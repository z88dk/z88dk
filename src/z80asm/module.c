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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/module.c,v 1.7 2014-05-17 23:08:03 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "module.h"

/*-----------------------------------------------------------------------------
*   Code section, one assembly instruction
*----------------------------------------------------------------------------*/
DEF_CLASS( CodeSection );

void CodeSection_init (CodeSection *self)   
{ 
	self->bytes = OBJ_NEW( Str );
	OBJ_AUTODELETE( self->bytes ) = FALSE;
}

void CodeSection_copy (CodeSection *self, CodeSection *other)
{
	self->bytes = Str_clone( other->bytes );
}

void CodeSection_fini (CodeSection *self)
{
	OBJ_DELETE( self->bytes );
}

/*-----------------------------------------------------------------------------
*   Assembly module
*----------------------------------------------------------------------------*/
DEF_CLASS( Module );

void Module_init (Module *self)   
{
	self->origin		= -1;
	self->start_offset	= get_codesize();

	self->local_symtab	= OBJ_NEW( SymbolHash );
	OBJ_AUTODELETE( self->local_symtab ) = FALSE;

	self->exprs			= OBJ_NEW( ExprList );
	OBJ_AUTODELETE( self->exprs ) = FALSE;
}

void Module_copy (Module *self, Module *other)	
{ 
	self->local_symtab = SymbolHash_clone( other->local_symtab );
	self->exprs = ExprList_clone( other->exprs ); 
}

void Module_fini (Module *self)
{ 
	OBJ_DELETE( self->local_symtab );
	OBJ_DELETE( self->exprs);
}

DEF_CLASS_LIST( Module );

/* 
* $Log: module.c,v $
* Revision 1.7  2014-05-17 23:08:03  pauloscustodio
* Change origin to int32_t, use -1 to signal as not defined
*
* Revision 1.6  2014/05/02 23:35:19  pauloscustodio
* Rename startoffset, add constant for NO_ORIGIN
*
* Revision 1.5  2014/05/02 20:24:38  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.4  2014/04/15 20:06:43  pauloscustodio
* Solve warning: no newline at end of file
*
* Revision 1.3  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.2  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.1  2013/06/08 22:57:13  pauloscustodio
* Embryo of Module structure
* 
*/
