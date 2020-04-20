

	MODULE generic_console_zxn

	SECTION	code_clib
	PUBLIC generic_console_zxn_tile_printc
	PUBLIC generic_console_zxn_tile_cls
	PUBLIC generic_console_zxn_tile_vpeek
	PUBLIC generic_console_zxn_tile_scrollup

	EXTERN	__console_w
	EXTERN	__console_h
	EXTERN	__zx_ink_colour


; Word for tiles:
; bits 15-12 : palette offset
; bit 11 : x mirror
; bit 10 : y mirror
; bit 9 : rotate
; bit 8 : ULA over tilemap (in 512 tile mode, bit 8 of the tile number)
; bits 7-0 : tile number

; Read register
;        ld      bc,0x243b
;        out     (c),l
;        inc     b
;        in      l,(c)
;        ld      h,0

; Tilemap address = port 0x6e
; Tiles address = port 0x6f
;
; Tilemap config:
; (R/W) 0x6B (107) => Tilemap Control
;  bit 7    = 1 to enable the tilemap
;  bit 6    = 0 for 40x32, 1 for 80x32
;  bit 5    = 1 to eliminate the attribute entry in the tilemap
;  bit 4    = palette select
;  bits 3-2 = Reserved set to 0
;  bit 1    = 1 to activate 512 tile mode
;  bit 0    = 1 to force tilemap on top of ULA

generic_console_zxn_tile_printc:
	push	de	
	call	xypos
	pop	de
	ld	(hl),d
	bit	5,a	;byte tile mode?
	ret	nz
	inc	hl
	ld	a,(__zx_ink_colour)
	rrca
	rrca
	rrca
	rrca
	and	@11110000
	ld	(hl),a	;No flags
	ret

generic_console_zxn_tile_vpeek:
	call	xypos
	ld	a,(hl)
	and	a
	ret

generic_console_zxn_tile_cls:
	ld	a,0x6e		;Tilemap base address
	ld	bc,0x243b
	out	(c),a
	inc	b
	in	h,(c)	
	ld	l,0
	ld	a,0x6b		;Tilemap control
	dec	b
	out	(c),a
	inc	b
	in	b,(c)		;Tilemap flags
	ld	de,(__console_w)	; e = width, d = height
	mlt	de
cls_1:
	ld	(hl),32
	inc	hl
	bit	5,b
	jr	nz,cls_is_byte
	ld	(hl),0
	inc	hl
cls_is_byte:
	dec	de
	ld	a,d
	or	e
	jr	nz,cls_1
	pop	bc
	pop	de
	ret

generic_console_zxn_tile_scrollup:
	push	bc
	push	de
	ld	a,0x6e		;Tilemap base address
	ld	bc,0x243b
	out	(c),a
	inc	b
	in	h,(c)	
	ld	l,0
	ld	a,0x6b		;Tilemap control
	dec	b
	out	(c),a
	inc	b
	in	e,(c)
	ld	a,(__console_w)	;width of console
	bit	5,e
	jr	nz,scrollup_byte_mode
	add	a
scrollup_byte_mode:
	ld	c,a		;bc is now width of each row
	ld	b,0
	ld	d,h		;Row 0
	ld	e,l
	add	hl,bc		;Row 1
	ld	a,(__console_h)
scrollup_1:
	push	bc		;Save width
	ldir
	pop	bc
	dec	a
	jr	nz,scrollup_1

	; And now clear out the bottom row
	ld	a,(__console_h)
	dec	a
	ld	b,a		;Get the coordinates of the bottom row
	ld	c,0
	ld	a,(__console_w)
scrollup_2:
	push	af
	push	bc
	ld	d,' '
	call	generic_console_zxn_tile_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jr	nz,scrollup_2

	pop	de
	pop	bc
	ret






; Entry: b = y, c = x
; Exit:  hl = address, a = nextreg 0x6b
xypos:
	push	bc
	ld	bc,0x243b
	ld	a,0x6b
	out	(c),a
	inc	b
	in	a,(c)
	pop	bc
	ld	hl, (__console_w)
	ld	h,0
	bit	5,a		;byte tiles if set
	jr	nz,is_byte_tiles
	add	hl,hl
is_byte_tiles:
        ld      de, 0
	ex	de,hl
	and	a
	sbc	hl,de
        inc     b
generic_console_printc_1:
        add     hl,de
        djnz    generic_console_printc_1
generic_console_printc_3:
        add     hl,bc                   ;hl now points to address in display
	bit	5,a		;byte tiles if set
	jr	nz,add_screen_address
	add	hl,bc			;For word screen mode
add_screen_address:
	ld	e,0x6e			;Tilemap base address
	ld	bc,0x243b
	out	(c),e
	inc	b
	in	b,(c)
	ld	c,0
	add	hl,bc
        ret	

	SECTION	code_crt_init

	EXTERN	asm_zxn_tilemap_palette
	call	asm_zxn_tilemap_palette
