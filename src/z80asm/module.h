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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/module.h,v 1.22 2014-09-28 17:37:14 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "classlist.h"
#include "classhash.h"
#include "codearea.h"
#include "expr.h"
#include "strutil.h"
#include "symtab.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Assembly module
*----------------------------------------------------------------------------*/
CLASS( Module )
	char		*modname;			/* module name, kept in strpool */
	char		*filename;			/* source file name, kept in strpool */
	int			 module_id;			/* sequence number of linked modules in sections */
    ExprList	*exprs;				/* list of expressions */
	SymbolHash	*local_symtab;		/* module local symbols */
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
