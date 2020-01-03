;
;
;	Quadrant mapping for the Exidy Sorcerer
;
;	$Id: textpixl.asm,v 1.3 2016-06-23 19:53:27 dom Exp $
;
;
;       .. X. .X XX
;       .. .. .. ..
;
;       .. X. .X XX
;       X. X. X. X.
;
;       .. X. .X XX
;       .X .X .X .X
;
;       .. X. .X XX
;       XX XX XX XX


        SECTION rodata_clib
	PUBLIC	textpixl


        defc    CHAR_TABLE = 0xfc00
	defc	X = 128 + 16

.textpixl
		defb	 X+0,     X+2,     X+1,  X+3
		defb 	 X+8,    X+10,     X+9, X+11
		defb	 X+4,     X+6,     X+5,  X+7
		defb	X+12,    X+14,    X+13,  X+15


	SECTION	code_crt_init

	ld	hl, CHAR_TABLE + 16 * 8
	xor	a
make_char_loop:
	ld	b,a
	ex	af,af
	call	create_char
	call	create_char
	ex	af,af
	inc	a
	cp	16
	jr	nz,make_char_loop

	SECTION	code_clib

create_char:
	rr	b
	sbc	a,a
	and	0x0f
	ld	c,a
	rr	b
	sbc	a,a
	and	0xf0
	or	c
	ld	c,4
loop:
	ld	(hl),a
	inc	hl
	dec	c
	jr	nz,loop
	ret
