/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Cross reference list of symbol usage
*/

#pragma once

#include "class.h"
#include "classlist.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Cross reference list of symbol usage
*----------------------------------------------------------------------------*/
CLASS( SymbolRef )
	int		page_nr;			/* page where symbol used/defined */
END_CLASS;

CLASS_LIST( SymbolRef );		/* list of references sorted by page_nr, with
								   definition reference at head of list */

/* add a symbol reference, create the list if NULL */
extern void add_symbol_ref( SymbolRefList *list, int page_nr, Bool defined );
