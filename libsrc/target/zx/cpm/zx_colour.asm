; 09.2009 stefano

; void __FASTCALL__ zx_colour(uchar colour)

SECTION code_clib
PUBLIC zx_colour
PUBLIC _zx_colour

	EXTERN	p3_poke

.zx_colour
._zx_colour

		ld 	a,l

		push af
		
;		ld	c,$0C
;		call 5
;		cp	$31		; Not CP/M 3.1
;		jr	nz,not3
;	
;		pop af
;		push af
;		ld hl,$2171
;		call p3_poke
;
;.not3

		ld hl,16384+6144
		ld de,768
loop:
		pop af
		push af
		call p3_poke
		inc hl
		dec de
		ld a,d
		or e
		jr nz,loop
		pop af

		ret

