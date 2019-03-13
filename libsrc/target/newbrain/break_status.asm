;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/03/2007
;
;
; Check if user pressed BREAK
; 1 if BREAK, otherwise 0
;
;
;
; $Id: break_status.asm,v 1.4 2016-06-19 20:33:40 dom Exp $
;

	SECTION code_clib
	PUBLIC break_status
	PUBLIC _break_status

.break_status
._break_status
	rst	20h
	defb	36h
	ld	hl,1
	ret	c
	dec	hl
	ret

