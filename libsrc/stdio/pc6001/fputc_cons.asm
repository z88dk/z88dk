;
; 	Basic video handling for the PC6001
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;
;----------------------------------------------------------------
;

	PUBLIC	fputc_cons

.fputc_cons

	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	12		; CLS
	jp	z,$1DFB

	cp	13
	jr	nz,nocr
	call	$26c7
	
	ld	a,10
.nocr	

	cp	8		; BS
	jr	nz,nobs
	ld	a,$1d
.nobs

	jp	$26c7
