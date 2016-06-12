;
;	PC-6001 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

fgetc_cons:
_fgetc_cons:
	call	$0FBC
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
