/*
 *      Part of the library for fcntlt
 *
 * 	Open a CPC file for reading
 * -----
 * $Id: cpc_openout.c,v 1.1 2003-09-12 16:30:43 dom Exp $
 */


#include "cpcfcntl.h"

int cpc_openout(char *name, int len, char *buf)
{
#asm
	INCLUDE		"#cpcfirm.def"
	LIB		cpc_setup_open
	call	cpc_setup_open
	call	cas_out_open
	ld	hl,1
	ret	c
	ld	hl,-1
#endasm
}

