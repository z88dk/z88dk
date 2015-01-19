;
;	ZX81 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000
;
;
;	$Id: getk.asm,v 1.5 2015-01-19 01:33:22 pauloscustodio Exp $
;

	PUBLIC	getk
	EXTERN	zx81toasc

        EXTERN    restore81

.getk
	call	restore81
	
	call	699
	ld	a,h
	add	a,2

	ld	b,h
	ld	c,l

	ld	a,0
	jr	c,nokey
	call	1981

	call	zx81toasc
nokey:
	ld	l,a
	ld	h,0
	ret
