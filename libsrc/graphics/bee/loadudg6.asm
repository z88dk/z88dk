;
;   MicroBEE pseudo graphics routines
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 2016
;
;
;	Load a 2x3 pseudo-graphics at HL position,
;   starting from character C up to character B-1
;
;
;	$Id: loadudg6.asm,v 1.2 2016-11-21 11:18:38 stefano Exp $
;

		        SECTION code_clib
			PUBLIC	loadudg6

.loadudg6
	;push bc
	ld  d,c
	call setbyte
	ld	(hl),a
	inc hl
	call setbyte
	call setbyte
	ld	(hl),a
	inc hl
	
	inc hl	; +5, to skip the character tail (11 lines visible out of 16)
	inc hl
	inc hl
	inc hl
	inc hl

	;pop  bc
	ld   c,d
	inc  c
	ld   a,b
	cp   c
	jr	 nz,loadudg6
	ret


.setbyte
    call setbyte2
	rr c
	rr c
	ld	(hl),a
	inc hl
	ld	(hl),a
	inc hl
	ld	(hl),a
	inc hl
	ret
.setbyte2
	xor a
	bit 0,c
	jr	z,noright
	ld	a,$0f
.noright
	bit 1,c
	ret z
	add $f0
	ret
