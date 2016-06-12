;
;	S-OS (The Sentinel) Japanese OS - Stdio
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
	call	1FD0h
	ld	l, a
	ld	h,0
	ret
