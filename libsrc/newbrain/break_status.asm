;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/03/2007
;
;
; Check if user pressed BREAK
; 1 if BREAK, otherwise 0
;

	XLIB break_status

.break_status
	rst	20h
	defb	36h
	ld	hl,1
	ret	c
	dec	hl
	ret

