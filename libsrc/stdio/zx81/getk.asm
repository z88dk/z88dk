;
;	ZX81 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000
;
;
;	$Id: getk.asm,v 1.3 2002-04-17 08:35:34 stefano Exp $
;

	XLIB	getk
	LIB	zx81_cnvtab

        XREF    save81
        XREF    restore81

.getk
	call	restore81
	
	call	699
	ld	a,h
	add	a,2
	jr	c,isntchar
	ld	b,h
	ld	c,l
	call	1981
	ld	a,(hl)
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
	ld	a,0
.setout
 		ld	l,a
		ld	h,0

	jp	save81
