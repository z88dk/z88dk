;
;       CLS for the Spectrum +3 CP/M
;       Stefano - 2016
;
;
;	$Id: clg.asm,v 1.1 2016-10-26 13:03:30 stefano Exp $
;

	SECTION	  code_clib
        PUBLIC    clg
        PUBLIC    _clg
	EXTERN	p3_poke
	EXTERN	zx_colour
	
.clg
._clg
	ld hl,16384
	ld de,6144
loop:
	xor a
	call p3_poke
	inc hl
	dec de
	ld a,d
	or e
	jr nz,loop
	
	ld l,7*8
	jp 	zx_colour
