
/*
 *	Open a popup window
 *
 *	GWL 26/3/00
 */

#include <z88.h>

static const char  winbot[] = "\x01" "2-S\x01" "2Y"; /* Move to window bottom string */
static const char  winlin[] = "\x01" "2*I\x01" "3N"; /* Bottom line string */
static const char  wincrn[] = "\0x5\0x1\2*L";   /* br corner string */

#if 0
#asm

._winbot	defm	1,"2-S",1,"2Y",0	; move to window bottom string
._winlin	defm	1,"2*I",1,"3N",0	; bottom line string
._wincrn	defm	5,1,"2*L",0		; br corner string

#endasm
#endif

void openpopup(int wid,int tlx,int tly,int width,int height,const char *name)
{
#asm
	EXTERN	opwin
	include	"stdio.def"
	push	ix
	ld	ix,4		; IX points to name
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
	ld	hl,_winbot
	call_oz(gn_sop)
	ld	a,(ix+2)
	add	a,$20
	call_oz(os_out)		; move to last row
	ld	hl,_winlin
	call_oz(gn_sop)		; bottom line string
	ld	a,(ix+4)
	add	a,$20
	call_oz(os_out)		; for width of window
	ld	hl,_wincrn
	call_oz(gn_sop)		; bottom right corner string
	dec	(ix+2)		; reduce height
	jp	opentitled	; continue, with titled version

#endasm
}

