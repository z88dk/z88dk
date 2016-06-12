;
;	PC-6001 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato, 2013
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	$0FBC
	jr	nz, key_got
	xor	a
key_got:
	ld	l, a
	ld	h,0
	ret
