
/*
 *	Open a popup window
 *
 *	GWL 26/3/00
 */

#include <z88.h>

void openpopup(int wid,int tlx,int tly,int width,int height,char *name)
{
#asm
	LIB	opwin
	include	"#stdio.def"

	ld	ix,2		; IX points to name
	add	ix,sp
	dec	(ix+6)		; decrement start row
	dec	(ix+8)		; & left
	inc	(ix+2)		; inc height twice (top/bottom)
	inc	(ix+2)
	inc	(ix+4)
	inc	(ix+4)
	ld	b,128
	call	opwin		; open window with nothing
	inc	(ix+6)		; restore parameters
	inc	(ix+8)
	dec	(ix+2)
	dec	(ix+2)
	dec	(ix+4)
	dec	(ix+4)
	ld	hl,winbot
	call_oz(gn_sop)
	ld	a,(ix+2)
	add	a,$20
	call_oz(os_out)		; move to last row
	ld	hl,winlin
	call_oz(gn_sop)		; bottom line string
	ld	a,(ix+4)
	add	a,$20
	call_oz(os_out)		; for width of window
	ld	hl,wincrn
	call_oz(gn_sop)		; bottom right corner string
	dec	(ix+2)		; reduce height
	jp	opentitled	; continue, with titled version

#endasm
}

#asm

.winbot	defm	1&"2-S"&1&"2Y"&0	; move to window bottom string
.winlin	defm	1&"2*I"&1&"3N"&0	; bottom line string
.wincrn	defm	5&1&"2*L"&0		; br corner string

#endasm
