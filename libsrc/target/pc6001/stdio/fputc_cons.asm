;
; 	Basic video handling for the PC6001
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.3 2016-05-15 20:15:46 dom Exp $
;
;----------------------------------------------------------------
;
	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native

	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	12		; CLS
	jp	z,$1DFB

IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocr
	call	$26c7
IF STANDARDESCAPECHARS	
	ld	a,13
ELSE
	ld	a,10
ENDIF
.nocr	

	cp	8		; BS
	jr	nz,nobs
	ld	a,$1d
.nobs

	jp	$26c7
