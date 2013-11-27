;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.1 2013-11-27 10:24:25 stefano Exp $
;

	XLIB	fgetc_cons

fgetc_cons:
	call	1FCAh 
	ld	l,a
	ld	h,0
	ret
