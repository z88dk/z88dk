
	SECTION	code_clib
	PUBLIC	printc_MODE2
	PUBLIC	scrollup_MODE2
	PUBLIC	generic_console_xypos_graphics

	EXTERN	__pc88_ink
	EXTERN	__pc88_paper
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	generic_console_flags

	EXTERN	l_push_di
	EXTERN	l_pop_ei
	EXTERN	__CLIB_PC8800_V2_ENABLED


	INCLUDE "target/pc88/def/pc88.def"

printc_MODE2:
        ld      a,d
        call    generic_console_xypos_graphics
        ex      de,hl           ;de = destination
        ld      bc,(generic_console_font32)
        ld      l,a
        ld      h,0
        bit     7,l
        jr      z,not_udg
        res     7,l
        ld      bc,(generic_console_udg32)
        inc     b
not_udg:
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,bc
        dec     h               ;-32 characters
        ex      de,hl           ;hl = screen, de = font


        ld      a,(generic_console_flags)
        rlca            ;get bit 7 out
        sbc     a
        ld      c,a     ; c = 0/ c = 255

	call	l_push_di
;IF ALU
	; I understand this code has no effect on a V1
	ld	a,__CLIB_PC8800_V2_ENABLED
	and	a
	jp	z,printc_skip_v2_setup
	ld	a,$80		;Turn on expanded gvram
	out	($35),a
	in	a,($32)		;Enable ALU
	set	6,a
	out	($32),a
;ENDIF
printc_skip_v2_setup:
	ld	b,8
loop:	push	bc
	ld	a,b
	cp	1
	jr	nz,not_last_row
	; It's the last row, check for bold
	ld	a,(generic_console_flags)
	bit	3,a
	jr	z,not_last_row
	ld	a,255		;Underline
	jr	no_bold
not_last_row:
	ld	a,(generic_console_flags)
	bit	4,a
	ld	a,(de)		;pick up font form main memory
	jr	z,no_bold
	ld	b,a
	rrca
	or	b
no_bold:
	xor	c
	ex	af,af
	ld	a,__CLIB_PC8800_V2_ENABLED
	and	a
	jp	z,printc_v1_only
	ex	af,af
	ld	c,a
	ld	a,(__pc88_ink)
	out	($34),a
	ld	(hl),c
	ld	a,c
	cpl
	ld	c,a
	ld	a,(__pc88_paper)
	out	($34),a
	ld	(hl),c
	jp	printc_next_row
printc_v1_only:
	ex	af,af
	exx
	ld	h,a		;save ink version
	cpl
	ld	l,a		;save paper version

	ld	de,(__pc88_ink)
	
	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	h
	ld	c,a	;Contains ink blue to be set

	rrc	d	;paper
	ld	a,d
	sbc	a,a	;255 if set, 0 = if not set
	and	l
	or	c	;So now we have the blue byte

	out	($5c),a	;Switch to blue
	exx
	ld	(hl),a	;And write it
	exx

	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	h
	ld	c,a	;Contains ink green to be set

	rrc	d	;paper
	ld	a,d
	sbc	a,a	;
	and	l
	or	c	;So now we have the green byte

	out	($5e),a	;Switch to green
	exx
	ld	(hl),a	;And write it
	exx

	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	h
	ld	c,a	;Contains ink green to be set

	rrc	d	;paper
	ld	a,d
	sbc	a,a	;
	and	l
	or	c	;So now we have the green byte

	out	($5d),a	;Switch to red
	exx
	ld	(hl),a	;And write it
	out	($5f),a	;Back to main memory

printc_next_row:
	inc	de
	ld	bc,80	;Next row
	add	hl,bc
	pop	bc
	djnz	loop
;IF ALU
	; This has no effect on a V1
	in	a,($32)		;Disable ALU
	res	6,a
	out	($32),a
	xor	a		;Turn off extended gbram
	out	($35),a
;ENDIF
	call	l_pop_ei
	ret

; Entry:
; c = x
; b = y
generic_console_xypos_graphics:
        ld      hl, $c000- 80 * 8
        ld      de, 80 * 8
        inc     b
generic_console_xypos_graphics_1:
        add     hl,de
        djnz    generic_console_xypos_graphics_1
        add     hl,bc
        ret

scrollup_MODE2:
	call	l_push_di
;IF ALU
	ld	a,__CLIB_PC8800_V2_ENABLED
	and	a
	jp	z,scrollup_v1_only
	ld	a,@10010000		;Turn on expanded gvram
	out	(EXPANDED_GVRAM_CTRL),a
	in	a,(ALU_MODE_CTRL)	;Enable ALU
	set	6,a
	out	(ALU_MODE_CTRL),a
	; Move up
	ld	hl,$c000 + 80 * 8
	ld	de,$c000
	ld	bc,80*192
	ldir
	; And now blank the bottom line with the current paper
	ex	de,hl	;hl
	ld	d,h
	ld	e,l
	inc	de
	ld	a,(__pc88_paper)
	ld	(hl),a
	ld	bc,+(80*8) -1
	ldir
	in	a,(ALU_MODE_CTRL)	;Disable ALU
	res	6,a
	out	(ALU_MODE_CTRL),a
	ld	a,$00			;Turn off expanded gvram
	out	(EXPANDED_GVRAM_CTRL),a
	jp	scroll_exit
;ELSE
scrollup_v1_only:
	ld	a,(__pc88_paper)
	ld	d,a
	out	($5c),a
	call	scroll_gfx
	out	($5e),a
	call	scroll_gfx
	out	($5d),a
	call	scroll_gfx
	ld	($5f),a
;ENDIF
scroll_exit:
	call	l_pop_ei
	pop	bc
	pop	de
	ret
	
scroll_gfx:
	ld	a,d
	ld	hl,$c000 + 80 * 8
	ld	de,$c000
	ld	bc,80*192
	ldir
	ex	de,hl	;hl
	ld	d,a
	rrc	d
	ld	a,d
	sbc	a
	push	de
	ld	d,h
	ld	e,l
	inc	de
	ld	(hl),a
	ld	bc,80*8
	ldir
	pop	de
	ret

