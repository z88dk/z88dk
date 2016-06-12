;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getkey() Wait for keypress, blinking cursor, etc..
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

.nokey
	rst	20h
	defb	39h
	jr	c,nokey
	rst	20h	; Convert Key code
	defb	3Ah
	ld	h,0
	ld	l,a
	ret

	;ld	e,0	; already waits for ENTER, then pushes all the keys.
	;rst	20h
	;defb	31h
	;ld	h,0
	;ld	l,a
	;ret
