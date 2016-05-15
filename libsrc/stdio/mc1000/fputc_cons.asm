;
; 	Basic video handling for the MC-1000
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:45 dom Exp $
;
;----------------------------------------------------------------
;
	SECTION	code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native

	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13		; CRLP
ENDIF
	jr	nz,nocr
	ld	a,10
	call setout
	ld	a,13
	jp setout
;	jr	z,$ca79
.nocr

	cp	12		; CLS
	jp	z,$C021

	; Some undercase text?  Transform in UPPER !
	cp	97
	jr	c,nounder
	sub	32
	jr	setout
.nounder
	; Transform the UPPER to INVERSE TEXT
	; Naah! That was orrible!
	;cp	65
	;jr	c,noupper
	;add	a,128
.noupper
	; Some more char remapping can stay here...
.setout

	ld	c,a
	jp	$C00C
