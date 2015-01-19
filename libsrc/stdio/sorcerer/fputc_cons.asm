;
;	ROM Console routine for  the Sorcerer Exidy
;	By Stefano Bodrato - 23/5/2011
;
;	$Id: fputc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC	fputc_cons

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
