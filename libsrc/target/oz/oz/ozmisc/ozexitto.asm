;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;
; ------
; $Id: ozexitto.asm,v 1.4 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozexitto
	PUBLIC	_ozexitto
	
	EXTERN	ozkeyclear
	EXTERN	ozungetch2
	EXTERN	cleanup		;exit


ozexitto:
_ozexitto:

	call ozkeyclear
	pop bc ;; retval
	pop hl ;; key
	
	push hl ;; put two copies of key on stack
	push hl
	call ozungetch2
	pop hl  ;; use previous copy of key on stack as argument
	call ozungetch2
	jp cleanup

