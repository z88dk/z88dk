;
;	ROM Console routine for the Robotron Z1013
;	By Stefano Bodrato - Aug. 2016
;
;	$Id: fputc_cons.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

	SECTION	code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	
	rst $20
	defb 0		; 'OUTCH' function

	ret
