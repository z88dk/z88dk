/*
 *      Part of the library for fcntlt
 *
 * 	Open a CPC file for reading
 * -----
 * $Id: cpc_openin.c,v 1.4 2015-01-21 14:00:11 stefano Exp $
 */


#include "cpcfcntl.h"

int cpc_openin(char *name, int len, char *buf)
{
#asm
	INCLUDE		"cpcfirm.def"
	EXTERN	cpc_setup_open
	call	cpc_setup_open
    call	firmware
	defw	cas_in_open
	ld	hl,1
	ret	c
	ld	hl,-1
#endasm
}

