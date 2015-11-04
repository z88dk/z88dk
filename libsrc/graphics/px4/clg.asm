;
;   CLS for the Epson PX4
;   Stefano - Nov 2015
;
;
;	$Id: clg.asm,v 1.1 2015-11-04 07:30:02 stefano Exp $
;

        PUBLIC    clg

.clg
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
