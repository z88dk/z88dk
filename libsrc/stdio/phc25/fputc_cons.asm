;
; 	Basic video handling for the PHC-25
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm $
;
;----------------------------------------------------------------
;
	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native

	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	; chr$(12) is CLS already

IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocr
	call	doputc
IF STANDARDESCAPECHARS	
	ld	a,13
ELSE
	ld	a,10
ENDIF
.nocr	

;	cp	8		; BS
;	jr	nz,nobs
;	ld	a,$----
;.nobs

.doputc
	ld	e,a
	ld 	a,(1)
	cp  $af
	ld	a,e
	jp	z,$108C		; Western ROM
	jp	$1089		; Japanese ROM
