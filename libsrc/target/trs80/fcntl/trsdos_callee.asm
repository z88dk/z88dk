
;
; Crazy way to call TRSDOS functions.
;
;
; On entry:
;		trsdos (function,HL,DE)  --or--  trsdos (function,A,DE)
;
; On exit: Return code = A   (e.g. an error code or the resulting value)
;


	SECTION	code_clib

	PUBLIC	trsdos_callee
	PUBLIC	_trsdos_callee

	EXTERN	errno

	PUBLIC	asm_trsdos

; int (unsigned int fn, char *hl_reg, char *de_reg);

	INCLUDE	"target/trs80/def/doscalls.def"

.trsdos_callee
._trsdos_callee
	POP BC	; ret addr
	
	POP	DE
	POP HL
	POP	IX
	
	PUSH BC

asm_trsdos:
	ld	bc,retaddr
	push bc
	
	ld	b,0
	ld	a,l
	
	JP	(IX)
	
retaddr:
	ld	l,a		; Error code
	ld	(errno),a
	ld	h,0
	
	ret

