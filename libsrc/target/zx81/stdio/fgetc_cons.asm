;
;	ZX81 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	EXTERN	zx81toasc

        EXTERN    restore81

.fgetc_cons
._fgetc_cons
	call	restore81
.fgcloop
IF FORlambda
	EXTERN  __lambda_keyboard
	call	__lambda_keyboard
ELSE
	call	699
ENDIF
	ld	a,h
	add	a,2
	jr	nc,fgcloop
.wloop
IF FORlambda
	call	__lambda_keyboard
ELSE
	call	699
ENDIF
	ld	a,h
	add	a,2
	jr	c,wloop
	ld	b,h
	ld	c,l
IF FORlambda
	EXTERN  __lambda_decode
	call	__lambda_decode
ELSE
	call	1981
ENDIF

	call	zx81toasc

	ld	l,a
	ld	h,0
	ret
