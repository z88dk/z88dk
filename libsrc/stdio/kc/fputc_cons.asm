;
;	Console routines for the Robotron VEB KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	$Id: fputc_cons.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;

	SECTION	code_clib
	PUBLIC	fputc_cons_native
	
	INCLUDE  "caos.def"

.fputc_cons_native
	ld	ix,$1f0
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
