;
; 	Basic video handling for the ZX81
;
;	(HL)=char to display
;
;	No text scroll with this:
;	simply your code will STOP when the last line is reached!!
;
;	With this you'll save a bit more than 1 Kbyte.
;	Useful if you want to use the 3K expansion.
;
;
;	$Id: fputc_cons.asm,v 1.2 2001-04-13 14:14:00 stefano Exp $
;

	XLIB	fputc_cons
	LIB	zx81_cnvtab

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	12
	jp	z,2602	; CLS
 	cp	48	; Between 0 and 9 ?
	jr	c,isntnum
	cp	58
	jr	nc,isntnum
	sub	20	; Ok, re-code to the ZX81 charset
	jr	setout	; .. and put it out
.isntnum
	cp	97	; Between a and z ?
	jr	c,isntlower
	cp	123
	jr	nc,isntlower
	sub	32	; Then transform in UPPER !
.isntlower
	cp	65	; Between A and Z ?
	jr	c,isntchar
	cp	91
	jr	nc,isntchar
	sub	27	; Ok, re-code to the ZX81 charset
	jr	setout	; .. and put it out
.isntchar
	ld	hl,zx81_cnvtab
.symloop
	inc	hl
	cp	(hl)
	jr	z,chfound
	inc	hl
	push	af
	xor	a
	or	(hl)
	jr	z,isntsym
	pop	af
	jr	symloop
.chfound
	dec	hl
	ld	a,(hl)
	jr	setout
.isntsym
	pop	af
	ld	a,0	; Else (space, exclamation mark, ..), blank.

.setout
	rst	16
	ret
