/*
 *	Rex 6000 Library
 *
 *	DsClearScreen()
 *
 *	Clears the screen
 */

#include <DataSlim.h> 

void DsClearScreen()
{
	int	i4,i3;
	int	sto;

	i4 = asm("in\ta,(4)\nld\tl,a\nld\th,0");
	i3 = asm("in\ta,(3)\nld\tl,a\nld\th,0");
	DsEventClear();
	asm("ld\ta,$10\nout\t($4),a");
	asm("xor\ta\nout\t($3),a");
#asm
	ld	ix,0
	add	ix,sp
	xor	a
	ld	(ix+0),a
	ld	(ix+1),a
.loop
	ld	bc,$8e10
	ld	l,(ix+0)
	ld	h,(ix+1)
	ld	a,$80
	xor	h
	ld	h,a
	sbc	hl,bc
	jr	nc,outloop
	ld	l,(ix+0)
	ld	h,(ix+1)
	ld	a,$a0
	add	a,h
	ld	h,a
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	add	a,4
	ld	(hl),a
	jr	nc,loop
	inc	hl
	inc	(hl)
	jr	loop
.outloop
	ld	a,(ix+4)
	out	($4),a
	ld	a,(ix+2)
	out	($3),a
#endasm
}


