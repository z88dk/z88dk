;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
; 	Internal code to convert a character from ZX81 to ASCII
;	in: source character in (HL)
;	out: A = converter character
;
;	$Id: zx81toasc.asm,v 1.6 2016-06-26 20:32:08 dom Exp $
;

SECTION code_clib
PUBLIC zx81toasc
EXTERN zx81_cnvtab

.zx81toasc
	ld	a,(hl)
	push	hl
	and	a	; space ?
	jr	nz,testnum
	ld	a,' '
	jr	setout
.testnum
 	cp	28	; Between 0 and 9 ?
	jr	c,isntnum
	cp	38
	jr	nc,isntnum
	add	20	; Ok, re-code to the ZX81 charset
	jr	setout	; .. and put it out
.isntnum
	cp	38	; Between A and Z ?
	jr	c,isntchar
	cp	64
	jr	nc,isntchar
	add	59	; Ok, lowercase
	jr	setout	; .. and put it out
.isntchar
	cp	166	; Between A and Z ?
	jr	c,isntchar1
	cp	192
	jr	nc,isntchar1
	sub 101	; Uppercase
	jr	setout	; .. and put it out
.isntchar1
	ld	hl,zx81_cnvtab
.symloop
	;inc	hl
	cp	(hl)
	jr	z,chfound
	push	af
	xor	a
	or	(hl)
	jr	z,isntsym
	pop	af
	inc	hl
	inc	hl
	jr	symloop
.chfound
	inc	hl
	ld	a,(hl)
	jr	setout
.isntsym
	pop	af
	ld	a,0	; Else blank.

.setout
	pop	hl
	ret
