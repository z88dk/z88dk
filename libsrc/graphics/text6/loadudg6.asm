;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 2014
;
;
;	Load a 2x3 pseudo-graphics at HL position,
;   starting from character C up to character B-1
;
;
;	$Id: loadudg6.asm,v 1.4 2015-01-19 01:32:51 pauloscustodio Exp $
;

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
