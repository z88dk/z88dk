
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer

; It works only with a _heap pointer defined somewhere else in the crt0.
; Such (long) pointer will hold, at startup, the (word) value of ASMTAIL
; that points to che last used byte in the compiled program:

;IF DEFINED_USING_amalloc
;EXTERN ASMTAIL
;PUBLIC _heap
;._heap
;	defw ASMTAIL	; Location of the last program byte
;	defw 0
;ENDIF


; $Id: amalloc.def,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $

	; HL must hold SP or the end of free memory
	push hl

	ld	hl,_heap
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc bc
	; compact way to do "mallinit()"
	xor	a
	ld	(hl),a
	dec hl
	ld	(hl),a

	pop hl	; sp
	sbc hl,bc	; hl = total free memory
	ld d,h
	ld e,l
	srl d
	rr e
	srl d
	rr e
IF DEFINED_USING_amalloc_2
	sbc hl,de	;  leave 2/4 of the free memory for the stack
IF DEFINED_USING_amalloc_1
	sbc hl,de	;  leave 3/4 of the free memory for the stack
ENDIF
ENDIF
	sbc hl,de	;  leave 1/4 of the free memory for the stack

	push bc ; main address for malloc area
	push hl	; area size
	EXTERN sbrk_callee
	call	sbrk_callee
