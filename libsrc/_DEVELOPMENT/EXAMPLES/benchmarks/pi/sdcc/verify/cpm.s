.area _CODE

_putchar::

   pop hl
	pop de
	push de
	push hl
	
	; E = char

	push ix
	push iy
	
	ld c,#2
	call #0x0005

	pop iy
	pop ix

   ret
	
_getchar::

	push ix
	push iy
	
	ld c,#1
	call #0x0005
	
	ld l,a
	ld h,#0
	
	pop iy
	pop ix
	
	ret
