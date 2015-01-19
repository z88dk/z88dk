;
;	ZX81 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.6 2015-01-19 01:33:22 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons
	EXTERN	zx81toasc

        EXTERN    restore81

.fgetc_cons
	call	restore81
.fgcloop
	call	699
	ld	a,h
	add	a,2
	jr	nc,fgcloop
.wloop
	call	699
	ld	a,h
	add	a,2
	jr	c,wloop
	ld	b,h
	ld	c,l
	call	1981

	call	zx81toasc

	ld	l,a
	ld	h,0
	ret
