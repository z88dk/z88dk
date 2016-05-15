;
;	ROM Console routine for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	$Id: fputc_cons.asm,v 1.3 2016-05-15 20:15:46 dom Exp $
;
        SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	jp	$C1BE
