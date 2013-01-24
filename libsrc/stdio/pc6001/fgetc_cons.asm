;
;	PC-6001 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.1 2013-01-24 15:31:38 stefano Exp $
;

	XLIB	fgetc_cons

fgetc_cons:
	call	$0FBC
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
