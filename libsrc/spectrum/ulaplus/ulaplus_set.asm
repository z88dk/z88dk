;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int ulaplus_set(attribute,rgbvalue);
;
;
;	$Id: ulaplus_set.asm,v 1.2 2015-01-19 01:33:11 pauloscustodio Exp $
;

	PUBLIC	ulaplus_set

ulaplus_set:
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
