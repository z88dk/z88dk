;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;
; ------
; $Id: ozexitto.asm,v 1.1 2003-10-23 10:42:50 stefano Exp $
;

	XLIB	ozexitto
	
	LIB	ozkeyclear
	LIB	ozungetch
	XREF	cleanup		;exit


ozexitto:

	call ozkeyclear
	pop bc ;; retval
	pop hl ;; key
	
	push hl ;; put two copies of key on stack
	push hl
	call ozungetch
	pop hl  ;; use previous copy of key on stack as argument
	call ozungetch
	jp cleanup

