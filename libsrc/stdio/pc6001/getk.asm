;
;	PC-6001 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato, 2013
;
;
;	$Id: getk.asm,v 1.1 2013-01-24 15:31:39 stefano Exp $
;

	XLIB	getk

.getk
	call	$0FBC
	jr	nz, key_got
	xor	a
key_got:
	ld	l, a
	ld	h,0
	ret
