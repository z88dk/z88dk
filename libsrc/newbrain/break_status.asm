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
; $Id: break_status.asm,v 1.2 2007-06-03 15:13:06 stefano Exp $
;


	XLIB break_status

.break_status
	rst	20h
	defb	36h
	ld	hl,1
	ret	c
	dec	hl
	ret

