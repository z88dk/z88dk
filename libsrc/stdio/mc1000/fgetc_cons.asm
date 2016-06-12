;
;	CCE MC-1000 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.7 2016-06-12 17:07:44 dom Exp $
;

; The code at entry $c009 checks if a key has been pressed in a 7ms interval.
; If so, A and (£012E) are set to $FF and the key code is put in (£011C).
; Otherwise, A and (£012E) are set to $00.

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

fgetc_cons:
_fgetc_cons:
	call $C006
	ld l,a
	ld h,0
	ret
