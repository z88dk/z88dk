;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
; in:	A = text row number
;
;

        SECTION  code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
	ld d,0
	ld e,a
	ld a,' '
	ld b,24
	
	jp $bfee
