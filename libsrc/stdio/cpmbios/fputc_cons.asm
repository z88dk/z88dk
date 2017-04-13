;
;	Console routines
;	Created for Robotron KC85 but kept generic
;	By Stefano Bodrato - Sept. 2016
;
;	$Id: fputc_cons.asm,v 1.1 2016-09-22 06:29:49 stefano Exp $
;

	SECTION	code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	
	ld  c,a
IF STANDARDESCAPECHARS
	cp  10
ELSE
	cp  13
ENDIF
	jr  nz,nocr
	call $f00c		; conout
IF STANDARDESCAPECHARS
	ld  c,13
ELSE
	ld  c,10
ENDIF
.nocr
	jp  $f00c		; conout
