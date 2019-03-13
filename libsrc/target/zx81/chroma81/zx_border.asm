; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

SECTION code_clib
PUBLIC zx_border
PUBLIC _zx_border

zx_border:
_zx_border:

	ld a,l
IF FORlambda
	jp 06E7h
ELSE
	and 15
	add	32+16	; 32=colour enabled,  16="attribute file" mode
	ld bc,7FEFh
	out (c),a
	ret
ENDIF
