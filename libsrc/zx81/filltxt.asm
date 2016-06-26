;
;	ZX81 libraries - Stefano 7/8/2009
;
;----------------------------------------------------------------
;
;	$Id: filltxt.asm,v 1.9 2016-06-26 20:32:08 dom Exp $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	SECTION code_clib
	PUBLIC   filltxt
	PUBLIC   _filltxt
	EXTERN    zx_topleft

filltxt:
_filltxt:
	; __FASTCALL__ mode
	ld	a,l
	
IF FORlambda
	ld	hl,16510
ELSE
	ld	hl,(16396)	; D_FILE
	inc	hl			; skip the first 'halt' instruction in the D-FILE
ENDIF

	ld	b,24
floop:
	push	bc
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	inc	hl

IF FORzx80
	push af
	ld	a,118
	ld	(hl),a
	pop af
ENDIF

	inc	hl
	pop	bc
	djnz 	floop

	jp  zx_topleft
