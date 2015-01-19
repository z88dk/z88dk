;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getkey() Wait for keypress, blinking cursor, etc..
;
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

.fgetc_cons

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
