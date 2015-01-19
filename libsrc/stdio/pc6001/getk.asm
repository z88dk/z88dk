;
;	PC-6001 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato, 2013
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	call	$0FBC
	jr	nz, key_got
	xor	a
key_got:
	ld	l, a
	ld	h,0
	ret
