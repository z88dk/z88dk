;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;
; ------
; $Id: ozexitto.asm,v 1.2 2003-10-27 16:56:57 stefano Exp $
;

	XLIB	ozexitto
	
	LIB	ozkeyclear
	LIB	ozungetch2
	XREF	cleanup		;exit


ozexitto:

	call ozkeyclear
	pop bc ;; retval
	pop hl ;; key
	
	push hl ;; put two copies of key on stack
	push hl
	call ozungetch2
	pop hl  ;; use previous copy of key on stack as argument
	call ozungetch2
	jp cleanup

