;
;	S-OS (The Sentinel) Japanese OS - Stdio
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
	call	1FD0h
	ld	l, a
	ld	h,0
	ret
