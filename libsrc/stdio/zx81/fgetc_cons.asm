;
;	ZX81 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.3 2002-04-17 08:35:34 stefano Exp $
;

	XLIB	fgetc_cons
	LIB	zx81_cnvtab

        XREF    save81
        XREF    restore81

.fgetc_cons
	call	restore81
	
	call	699
	ld	a,h
	add	a,2
	jr	nc,fgetc_cons
.wloop
	call	699
	ld	a,h
	add	a,2
	jr	c,wloop
	ld	b,h
	ld	c,l
	call	1981
	ld	a,(hl)
	and	a
	jr	nz,nospace
	ld	a,32
	jr	setout
.nospace
	cp	28	; Between 0 and 9 ?
	jr	c,isntnum
	cp	38
	jr	nc,isntnum
	add	a,20	; Ok, re-code to the ASCII charset
	jr	setout	; .. and put it out
.isntnum
	cp	38	; Between A and Z ?
	jr	c,isntchar
	cp	64
	jr	nc,isntchar
	add	a,27	; Ok, re-code to the ASCII charset
	jr	setout	; .. and put it out
.isntchar
	ld	hl,zx81_cnvtab
.symloop
	cp	(hl)
	jr	z,chfound
	inc	hl
	inc	hl
	push	af
	xor	a
	or	(hl)
	jr	z,isntsym
	pop	af
	jr	symloop
.chfound
	inc	hl
	ld	a,(hl)
	jr	setout
.isntsym
	pop	af

	ld	a,0
.setout
	ld	l,a
	ld	h,0
	
	jp	save81
