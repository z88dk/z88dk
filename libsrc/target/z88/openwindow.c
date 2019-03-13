
/*
 *	Open a plain (left & right bars only) window
 *
 *	GWL 26/3/00
 */

#include <z88.h>

void openwindow(int wid,int tlx,int tly,int width,int height)
{
#asm
	EXTERN	opwin

	push	ix
	ld	ix,2
	add	ix,sp
	ld	b,129		; left & right bars
	call	opwin
	pop	ix
#endasm
}

