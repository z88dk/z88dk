/*
 *	Call a CPM BDOS routine
 *
 *	$Id: bios.c,v 1.3 2015-11-11 18:40:54 stefano Exp $
 */

#include <cpm.h>


int bios(int func,int arg,int arg2)
{
#asm
	ld	hl,2
	add	hl,sp
	ld	e,(hl)	;arg2
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)	;arg
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	a,(hl)  ; get function number (1-85)
	
	ld hl,(1)   ; base+1 = addr of jump table + 3

	dec hl
	dec hl
	dec hl
	
	push de
	ld  e,a     ; multiply by 3
	add a,a
	add a,e
	
	ld  e,a
	ld  d,0
	add hl,de   ; add to base of jump table
	pop de

	push hl     ; save it

	ld  hl,retadd
	ex  (sp),hl
	jp  (hl)

retadd:
	ld	l,a     ; all done. now put return value in HL
	ld	h,0
#endasm
}
