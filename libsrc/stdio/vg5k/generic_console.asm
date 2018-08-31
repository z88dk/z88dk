

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		__vg5k_custom_font

		EXTERN		__vg5k_attr
		EXTERN		conio_map_colour
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x4000

generic_console_set_inverse:
	ret

generic_console_set_paper:
	call	conio_map_colour
	rlca
	rlca
	rlca
	rlca
	and	@01110000
	ld	c,a
	ld	hl,__vg5k_attr
	ld	a,(hl)
	and	@10001111
	or	c
	ld	(hl),a
	ret


generic_console_set_ink:
	call	conio_map_colour
	and	7
	ld	c,a
	ld	hl,__vg5k_attr
	ld	a,(hl)
	and	@11111000
	or	c
	ld	(hl),a
	ret

generic_console_cls:
	ld	c,CONSOLE_ROWS
	ld	hl, DISPLAY
	ld	a,(__vg5k_attr)
	and	7
cls0:
	ld	b,CONSOLE_COLUMNS 
cls1:	ld	(hl),32
	inc	hl
	ld	(hl),a
	inc	hl
	djnz	cls1
	dec	c
	jr	nz,cls0
	call	refresh_screen
	ret


;
;First byte of the pair has this layout:
;
;+---------+-------------+---------------------------+
;| Bit     | 7           | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
;+---------+-------------+---------------------------+
;| Content | N (0)/E (1) |     character number      |
;+---------+-------------+---------------------------+
;
;The second byte of the pair has this layout:
;
;+---------+--------+---------+----------+-----------+-------+-----+------+-----+
;| Bit     | 7      |    6    |     5    |     4     |   3   |  2  |   1  |  0  |
;+---------+--------+---------+----------+-----------+-------+-----+------+-----+
;| Content | TX (0) | Reverse | Width x2 | Height x2 | Blink |       Color      |
;+---------+--------+---------+----------+-----------+-------+------------------+
;| Content | GR (1) |         Background Color       | Blink | Foreground Color |
;+---------+--------+--------------------------------+-------+------------------+
;
;With N/E (Normal/Extended) and TX/GR, the selection of the character set is made.
;This corresponds to the various graphic selections in BASIC.
;Normal TX is TX, Extended TX is ET, Normal GR is GR, Extended GR is EG.
;Extended mode allows character redefinition.
;Normal text is ASCII, normal graphics is the Semi-Graphic character set.

; Entry:
; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	d,a	
	push	bc	;save coordinates
	push	de
	call	xypos
	pop	de
	ld	a,(__vg5k_attr)	; d = character, c = attribute
	ld	c,a
	bit	0,e
	jr	z,not_raw

; Raw mode, if > 128 then graphics
	bit	7,d
	jr	z, place_text
	res	7,d
	set	7,c
	jr	place_it

not_raw:
	; If d > 128 then we need graphics + extended
	bit	7,d
	jr	z,not_udg
	ld	a,d
	add	32
	ld	d,a
	set	7,c
	jr	place_it
not_udg:
	ld	a,(__vg5k_custom_font)
	and	a
	jr	z,place_text
	set	7,d		;extended character set
place_text:
	ld	a,c		;don't set reverse/double etc
	and	@10001111
	ld	c,a
place_it:
	ld	(hl),d			;place character
	inc	hl
	ld	(hl),c
	ld	e,c
	pop	hl			;get coordinates back
	ld	a,h
	and	a
	jr	z,zrow
	add	7
	ld	h,a
zrow:
	call	0x0092			;call the rom to do the hardwork
	ret

xypos:
	ld	hl,DISPLAY - 80
	ld	de,80
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
	add	hl,bc		
	add	hl,bc			;hl now points to address in display
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	d,(hl)
	ld	a,d
	res	7,a		;never high
	inc	hl
	bit	7,(hl)	
	jr	z,vpeek_done	;not graphics
	bit	7,d		;is it a udg
	jr	z,not_vpeek_udg
	sub	32		;UDG offset
not_vpeek_udg:
	set	7,a
vpeek_done:
	and	a
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + 80
	ld	de, DISPLAY
	ld	bc, 80 * (CONSOLE_ROWS-1)
	ldir
	ex	de,hl
	ld	a,(__vg5k_attr)
	and	7
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_3
	call	refresh_screen
	pop	bc
	pop	de
	ret

; Refresh the whole VG5k screen - we can't rely on the interrupt
refresh_screen:
	ld	bc,CONSOLE_ROWS * CONSOLE_COLUMNS
	ld	hl,0		
	ld	de,DISPLAY
refresh_screen1:
	push	bc
	push	hl
	ld	a,(de)
	inc	de
	ex	af,af
	ld	a,(de)		;attribute
	inc	de
	push	de
	ld	e,a		;attribute
	ex	af,af
	ld	d,a		;character
	call	$0092
	pop	de
	pop	hl
	inc	l
	ld	a,l
	cp	40
	jr	nz,same_line
	ld	l,0
	ld	a,h
	and	a
	jr	nz,increment_row
	ld	h,7
increment_row:
	inc	h
same_line:
	pop	bc
	dec	bc
	ld	a,b
	or	c
	jr	nz,refresh_screen1
	ret


	SECTION		bss_clib

__vg5k_custom_font:	defb	0


	SECTION		code_crt_init
	EXTERN	set_character8
	EXTERN	CRT_FONT

	ld	hl,CRT_FONT
	ld	a,h
	or	l
	jr	z,no_set_font
	ld	a,1
	ld	(__vg5k_custom_font),a
        ld      b,96
        ld      c,32
set_font:
        push    bc
        push    hl
        call    set_character8
        pop     hl
	ld	bc,8
	add	hl,bc
        pop     bc
        inc     c
        djnz    set_font
no_set_font:
