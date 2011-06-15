;
;	ROM Console routine for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	$Id: fputc_cons.asm,v 1.1 2011-06-15 20:15:00 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	jp	$C1BE
