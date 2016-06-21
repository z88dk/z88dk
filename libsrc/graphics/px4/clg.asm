;
;   CLS for the Epson PX4
;   Stefano - Nov 2015
;
;
;	$Id: clg.asm,v 1.3 2016-06-21 20:16:35 dom Exp $
;

	SECTION	code_clib
        PUBLIC    clg
        PUBLIC    _clg

.clg
._clg
		ld c,27	; ESC
		call $eb0c	; CONOUT
		ld c,'2'  ; Hide cursor
		call $eb0c	; CONOUT
		xor a
		ld ($f2ad),a	; LVRAMYOF
;		ld	hl,($f294)	; LSCVRAM
		ld  hl,$e000

		ld (hl),a
		ld d,h
		ld e,l
		inc de
		ld bc,2047
		ldir
		ret
