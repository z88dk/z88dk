; 12.2014 stefano

; void __FASTCALL__ zx_colour(uchar colour)

SECTION code_clib
PUBLIC zx_colour
PUBLIC _zx_colour
EXTERN HRG_LineStart

.zx_colour
._zx_colour
		ld 	a,l
IF FORlambda
   ld hl,8319
ELSE
   ld hl,HRG_LineStart+2+32768
ENDIF

		ld	c,24
.rowloop
		ld	b,32
.rowattr
		ld	(hl),a
		inc hl
		djnz rowattr
IF FORlambda
		inc	hl
ELSE
		inc	hl
		inc	hl
		inc	hl
ENDIF
		dec c
		jr  nz,rowloop
		ret
