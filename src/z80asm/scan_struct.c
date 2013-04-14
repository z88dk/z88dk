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

Copyright (C) Paulo Custodio, 2011-2013

Stack of nested constructs on each context in scanner

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan_struct.c,v 1.1 2013-04-14 18:17:00 pauloscustodio Exp $
$Log: scan_struct.c,v $
Revision 1.1  2013-04-14 18:17:00  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.


*/

#include "memalloc.h"	/* before any other include */

#include "errors.h"
#include "scan_struct.h"


/*-----------------------------------------------------------------------------
*   Stack of nested constructs on each context
*----------------------------------------------------------------------------*/
DEF_CLASS(Struct);
DEF_CLASS_LIST(Struct);

void Struct_init( Struct *self ) { }

void Struct_copy( Struct *self, Struct *other ) { }

void Struct_fini( Struct *self ) { }

/*-----------------------------------------------------------------------------
*   return top of stack, ERR_UNBALANCED_STRUCT if stack empty
*----------------------------------------------------------------------------*/
static Struct *StructList_top( StructList *self )
{
	if ( StructList_empty( self ) )
	{
		error( ERR_UNBALANCED_STRUCT );
		return NULL;
	}
	else
	{
		return StructList_last( self )->obj;
	}
}

/*-----------------------------------------------------------------------------
*   push start of new nested struct to stack
*----------------------------------------------------------------------------*/
void StructList_start( StructList *self, int id, int value, int line_nr )
{
	Struct *elem;
	
	elem = OBJ_NEW( Struct );
	elem->id 		= id;
	elem->value 	= value;
	elem->line_nr	= line_nr;
	
	StructList_push( self, elem );
}

/*-----------------------------------------------------------------------------
*   return top id, value; ERR_UNBALANCED_STRUCT and return -1 if stack empty
*----------------------------------------------------------------------------*/
int StructList_top_id( StructList *self )
{
	Struct *elem = StructList_top( self );
	return elem ? elem->id : SCAN_ERR_ID;
}

int StructList_top_value( StructList *self )
{
	Struct *elem = StructList_top( self );
	return elem ? elem->value : SCAN_ERR_ID;
}

/*-----------------------------------------------------------------------------
*   replace id, value of top; ERR_UNBALANCED_STRUCT if stack empty
*----------------------------------------------------------------------------*/
void StructList_replace( StructList *self, int id, int value, int line_nr )
{
	Struct *elem = StructList_top( self );
	if ( elem != NULL )
	{
		elem->id 		= id;
		elem->value 	= value;
		elem->line_nr	= line_nr;
	}
}

/*-----------------------------------------------------------------------------
*   pop end of nested struct from stack; 
*   ERR_UNBALANCED_STRUCT if stack empty or id does not match top
*----------------------------------------------------------------------------*/
void StructList_end( StructList *self, int id )
{
	Struct *elem = StructList_pop( self );
	if ( elem == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		if ( elem->id != id ) 
		{
			error( ERR_UNBALANCED_STRUCT_AT, elem->line_nr );
		}
		
		OBJ_DELETE( elem );	
	}		
}
