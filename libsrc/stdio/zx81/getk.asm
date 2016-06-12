;
;	ZX81 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000
;
;
;	$Id: getk.asm,v 1.7 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	zx81toasc

        EXTERN    restore81

.getk
._getk
	call	restore81
	
IF FORlambda
	call	3444
ELSE
	call	699
ENDIF
	ld	a,h
	add	a,2

	ld	b,h
	ld	c,l

	ld	a,0
	jr	c,nokey
IF FORlambda
	call	6263
ELSE
	call	1981
ENDIF

	call	zx81toasc
nokey:
	ld	l,a
	ld	h,0
	ret
