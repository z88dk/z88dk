;
; 	Basic video handling for the MC-1000
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.3 2013-03-08 13:40:20 stefano Exp $
;
;----------------------------------------------------------------
;

	XLIB	fputc_cons

.fputc_cons

	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	13		; CRLP
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
