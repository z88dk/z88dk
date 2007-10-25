;
;	ZX81 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000
;
;
;	$Id: getk.asm,v 1.4 2007-10-25 17:10:54 stefano Exp $
;

	XLIB	getk
	LIB	zx81toasc

        XREF    restore81

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
