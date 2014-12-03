; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

XLIB zx_border

zx_border:

	ld a,l
	and 15
	add	32+16	; 32=colour enabled,  16="attribute file" mode
	ld bc,7FEFh
	out (c),a
	ret
