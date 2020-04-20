IF FORzxn

	SECTION	code_graphics

	PUBLIC	asm_zxn_tilemap_palette

;
; Set the tilemap palette to something that approximates ANSI colours
;
;
asm_zxn_tilemap_palette:
	nextreg	$43,$30		;Select tilemap palette 1
	nextreg	$40,$00		;Start off at palette index 0

	ld	e,0
	ld	b,0
loop1:
	ld	a,(palette)		;Paper colour
	nextreg	$41,a		
	ld	c,e
	ld	d,15
loop2:
	ld	hl,palette
	add	hl,bc
	ld	a,(hl)
	nextreg	$41,a		
	ld	a,c
	inc	a
	and	15
	ld	c,a
	dec	d
	jr	nz,loop2
	inc	e
	ld	a,e
	cp	16
	jr	nz,loop1
	ret




;        __ZXN_RGB332_NEXTOS_BLACK,
;        __ZXN_RGB332_NEXTOS_BLUE,
;        __ZXN_RGB332_NEXTOS_GREEN,
;        __ZXN_RGB332_NEXTOS_CYAN,
;        __ZXN_RGB332_NEXTOS_RED,
;        __ZXN_RGB332_NEXTOS_MAGENTA,
;        __ZXN_RGB332_INSTAGRAM_BROWN,
;        __ZXN_RGB332_MONO_GRAY_2,
;        __ZXN_RGB332_MONO_GRAY_1,
;        __ZXN_RGB332_NEXTOS_BRIGHT_BLUE,
;        __ZXN_RGB332_NEXTOS_BRIGHT_GREEN,
;         __ZXN_RGB332_NEXTOS_BRIGHT_CYAN,
;        __ZXN_RGB332_NEXTOS_BRIGHT_RED,
;        __ZXN_RGB332_NEXTOS_BRIGHT_MAGENTA,
;        __ZXN_RGB332_NEXTOS_YELLOW,
;        __ZXN_RGB332_NEXTOS_WHITE

	SECTION	data_arch
palette:
         defb	0x00, 0x02, 0x14, 0x16, 0xa0, 0xa2, 0xad, 0x92, 0x49, 0x03, 0x1c, 0x1f, 0xe0, 0xe7, 0xb4, 0xb6

ENDIF
