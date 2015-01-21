/*
 *	Check the file handle is okay...
 *
 *	djm 25/1/2000
 *
 *	Used by fread/fwrite
 */

#include <stdio.h>


int fchkhdl(FILE *fp)
{
#asm
	EXTERN	fhand_ck
	pop	de
	push	de
	call	fhand_ck
	ld	hl,0	;failure...
	ret	z
	inc	hl
#endasm
}





