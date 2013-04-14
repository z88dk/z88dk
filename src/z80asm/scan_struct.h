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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan_struct.h,v 1.1 2013-04-14 18:17:00 pauloscustodio Exp $
$Log: scan_struct.h,v $
Revision 1.1  2013-04-14 18:17:00  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.


*/

#ifndef SCAN_STRUCT_H
#define SCAN_STRUCT_H

#include "memalloc.h"	/* before any other include */

#include "class.h"
#include "classlist.h"

/*-----------------------------------------------------------------------------
*   Constants
*----------------------------------------------------------------------------*/
#define SCAN_ERR_ID		-1		/* ID returned by top_id and top_value on error */

/*-----------------------------------------------------------------------------
*   Stack of nested constructs on each context
*----------------------------------------------------------------------------*/
CLASS(Struct)
	int		id;					/* user-defined ID */
	int		value;				/* user-defined VALUE */
	int		line_nr;			/* line where struct started */
END_CLASS;
CLASS_LIST(Struct);

/* push start of new nested struct to stack */
extern void StructList_start( StructList *self, int id, int value, int line_nr );

/* return top id, value; ERR_UNBALANCED_STRUCT and return -1 if stack empty */
extern int  StructList_top_id( StructList *self );
extern int  StructList_top_value( StructList *self );

/* replace id, value of top; ERR_UNBALANCED_STRUCT if stack empty */
extern void StructList_replace( StructList *self, int id, int value, int line_nr );

/* pop end of nested struct from stack; 
   ERR_UNBALANCED_STRUCT if stack empty or id does not match top */
extern void StructList_end( StructList *self, int id );


#endif /* ndef SCAN_STRUCT_H */
