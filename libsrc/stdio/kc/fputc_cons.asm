;
;	Console routines for the Robotron VEB KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	$Id: fputc_cons.asm,v 1.1 2016-10-03 06:38:15 stefano Exp $
;

	SECTION	code_clib
	PUBLIC	fputc_cons_native
	
	INCLUDE  "caos.def"

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp  13
	jr  nz,nocr
	call PV1
	defb FNCRT
	ld  a,10
.nocr
	call PV1
	defb FNCRT
	ret
