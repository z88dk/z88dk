;
;	ROM Console routine for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	$Id: fputc_cons.asm,v 1.2 2015-01-19 01:33:22 pauloscustodio Exp $
;

	PUBLIC	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	jp	$C1BE
