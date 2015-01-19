;
;	PC-6001 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

fgetc_cons:
	call	$0FBC
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
