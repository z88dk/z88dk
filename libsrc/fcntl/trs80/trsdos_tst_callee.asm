
;
; Crazy way to call TRSDOS functions.
;
;
; On entry:
;		trsdos_tst (function,HL,DE)  --or--  trsdos (function,A,DE)
;
; On exit: Return code = 0 if zero, -1 if not zero
;


	SECTION	code_clib

	PUBLIC	trsdos_tst_callee
	PUBLIC	_trsdos_tst_callee

	EXTERN	errno

	PUBLIC	ASMDISP_TRSDOS_TST_CALLEE

; int (unsigned int fn, char *hl_reg, char *de_reg);

	INCLUDE	"target/trs80/def/doscalls.def"

.trsdos_tst_callee
._trsdos_tst_callee
	POP BC	; ret addr
	
	POP	DE
	POP HL
	POP	IX
	
	PUSH BC

centry:
	ld	bc,retaddr
	push bc
	
	ld	b,0
	ld	a,l
	
	JP	(IX)
	
retaddr:
	ld	(errno),a
	ld	hl,0
	ret z
	dec hl	; -1 if NZ
	
	ret


DEFC ASMDISP_TRSDOS_TST_CALLEE = centry - trsdos_tst_callee
