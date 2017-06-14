;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
	ld BC,0x7f18
	
_bel_loop:
	ld A,0x80
	out (C), A
	call _wait
	xor A
	out (C), A
	call _wait
	djnz _bel_loop
	ret

_wait:
	push BC
	ld B,0
_wait_loop:
	djnz _wait_loop
	pop BC
	ret
