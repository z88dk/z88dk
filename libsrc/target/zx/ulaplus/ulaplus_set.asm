;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int ulaplus_set(attribute,rgbvalue);
;
;
;	$Id: ulaplus_set.asm,v 1.3 2016-06-10 21:14:23 dom Exp $
;


	SECTION code_clib
	PUBLIC	ulaplus_set
	PUBLIC	_ulaplus_set

ulaplus_set:
_ulaplus_set:
	pop	bc
	pop de
	pop hl
	push hl
	push de
	push bc

	ld	bc,$bf3b
	ld	a,l
	and	63		; mask to be sure we're setting the palette
	out	(c),a

	ld	b,$ff
	ld	a,e
	out	(c),a
	ret
