;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato, 2013
;
;
;	$Id: getk.asm,v 1.1 2013-11-27 10:24:25 stefano Exp $
;

	XLIB	getk

.getk
	call	1FD0h
	ld	l, a
	ld	h,0
	ret
