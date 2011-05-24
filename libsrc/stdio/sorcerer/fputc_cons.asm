;
;	ROM Console routine for  the Sorcerer Exidy
;	By Stefano Bodrato - 23/5/2011
;
;	$Id: fputc_cons.asm,v 1.1 2011-05-24 18:11:10 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	13
	jr	nz,nocrlf
	call $e00c
	ld	a,10
.nocrlf
	jp $e00c
