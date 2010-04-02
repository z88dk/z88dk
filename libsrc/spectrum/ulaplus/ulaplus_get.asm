;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int ulaplus_get(attribute);
;
;	$Id: ulaplus_get.asm,v 1.1 2010-04-02 09:05:06 stefano Exp $
;

	XLIB	ulaplus_get

ulaplus_get:
	;__FASTCALL__
	ld	bc,$bf3b
	ld	a,l
	and	63		; mask to be sure we're reading the palette
	in	a,(c)	; see if ULAPlus got palette mode
	ld	l,a
	ld	h,0
	ret
