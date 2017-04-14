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
IF STANDARDESCAPECHARS
	cp  10
ELSE
	cp  13
ENDIF
	jr  nz,nocr
	call PV1
	defb FNCRT
IF STANDARDESCAPECHARS
	ld  c,13
	call PV1
	defb FNCRT
	ld  c,10
ELSE
	call PV1
	defb FNCRT
	ld  c,10
ENDIF
.nocr
	call PV1
	defb FNCRT
	ret
