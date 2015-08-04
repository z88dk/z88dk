;
;	ZX81 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.7 2015-08-04 15:33:51 stefano Exp $
;

	PUBLIC	fgetc_cons
	EXTERN	zx81toasc

        EXTERN    restore81

.fgetc_cons
	call	restore81
.fgcloop
IF FORlambda
	call	3444
ELSE
	call	699
ENDIF
	ld	a,h
	add	a,2
	jr	nc,fgcloop
.wloop
IF FORlambda
	call	3444
ELSE
	call	699
ENDIF
	ld	a,h
	add	a,2
	jr	c,wloop
	ld	b,h
	ld	c,l
IF FORlambda
	call	6263
ELSE
	call	1981
ENDIF

	call	zx81toasc

	ld	l,a
	ld	h,0
	ret
