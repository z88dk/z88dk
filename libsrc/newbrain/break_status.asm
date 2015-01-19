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
; $Id: break_status.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC break_status

.break_status
	rst	20h
	defb	36h
	ld	hl,1
	ret	c
	dec	hl
	ret

