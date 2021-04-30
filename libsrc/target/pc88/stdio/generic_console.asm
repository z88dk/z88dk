

	SECTION		code_clib

	PUBLIC		generic_console_cls
	PUBLIC		generic_console_vpeek
	PUBLIC		generic_console_plotc
	PUBLIC		generic_console_printc
	PUBLIC		generic_console_scrollup
        PUBLIC          generic_console_set_ink
        PUBLIC          generic_console_set_paper
        PUBLIC          generic_console_set_attribute
	PUBLIC		generic_console_pointxy
	PUBLIC		__pc88_clear_text
	PUBLIC		__pc88_clear_hires

	EXTERN		CONSOLE_COLUMNS
	EXTERN		CONSOLE_ROWS
	EXTERN		asm_toupper
	EXTERN		l_push_di
	EXTERN		l_pop_ei
	EXTERN		__pc88_mode
	EXTERN		__pc88_ink
	EXTERN		__pc88_textink
	EXTERN		__pc88_paper
	EXTERN		printc_MODE2
	EXTERN		scrollup_MODE2
	EXTERN		vpeek_MODE2
	EXTERN		__pc88_attr
	EXTERN		generic_console_flags
	EXTERN		__console_x
	EXTERN		__CLIB_PC8800_V2_ENABLED

	INCLUDE	"target/pc88/def/pc88.def"

	defc		DISPLAY = 0xf3c8



generic_console_set_paper:
	and	7
	ld	(__pc88_paper),a
	ret

generic_console_set_ink:
	and	7
	ld	(__pc88_ink),a
	rrca
	rrca
	rrca
	or	8	;colour specification
	ld	(__pc88_textink),a
	ret

generic_console_set_attribute:
	ld	hl,__pc88_attr
	ld	(hl),0
	ld	a,(generic_console_flags)
	bit	7,a
	jr	z,not_inverse
	set	2,(hl)
not_inverse:
	bit	3,a	;underline
	jr	z,not_underline
	set	5,(hl)
not_underline:
	bit	2,a
	jr	z,no_blink
	set	1,(hl)
no_blink:
	bit	4,a
	ret	z
	set	4,(hl)
	set	5,(hl)
	ret


; Entry:  b = y
;	  c = x (scale to 80)
;	  e = colour
;	  d = decoration
insert_attribute:
	push	de	;save attributue
	push	bc	;save cooards
	call	xypos_attr_row
	ld	hl,expand_buf
	exx
	push	ix
	call	expand		;So we now have an expanded buffer
	pop	hl		;screen attributes into hl'
	exx
	pop	bc		;coordinates
	ld	hl,expand_buf
	ld	b,0
	add	hl,bc
	add	hl,bc
	pop	de		;attribute back
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ld	a,(__pc88_mode)
	cp	1
	jr	nz,no_40col_attr
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
no_40col_attr:
	ld	ix,expand_buf
	call	compress
	ret

	


load_attributes:
        inc     ix
        inc     ix      ;Now points to next attribute X coord
        bit     3,(ix-1)
        jr      z,is_decoration
        ld      c,(ix-1)
        ret
is_decoration:
        ld      b,(ix-1)
        ret


; Entry:        ix  = screen
;               hl' = expanded buffer
expand:
        ; In flight we use c' as colour, b' as decoration
        exx
        ld      bc,$00e8
        call    load_attributes
        exx

        ld      b,0     ;80 columns needed
        ld      c,19    ;20 attributes available

expand_loop:
                ; Have we expanded all the attribute columns?
        ld      a,c
        and     a
        jr      z,place_attr
                ; If it's a placeholder then just copy existing values
        ld      a,(ix+0)
        bit     7,a
        jr      nz,place_attr
                ; Is the column in the attr map where we expanding to?
        cp      b
                ; Nope, just keep padding out
        jr      nz,place_attr
                ; We've got to the column where the new attribute starts
        exx
        call    load_attributes
        exx
        dec     c               ;We've loaded an attribute

place_attr:
        inc     b               ;We're about to place another column
        exx
        ld      (hl),c
        inc     hl
        ld      (hl),b
        inc     hl
        exx
        ld      a,b
        cp      80
        jr      nz,expand_loop
        ret

; Recompress the expanded buffer into the compresse attributes
; If colour + deco exchange rapidly then the attributes will
; be misplaced
compress:
	ld	b,1
        ld      c,20            ;20 attribute spaces
        ; ix = expanded buffer
        ; hl' = screen buffer
        ; c' = current colour
        ; b' = current decoration
        ; e' = current attr column
        exx
        ld      de,0             ;current attr column
		; We need to place an attribute at column 0, so fudge
		; around and place one of them
        ld      c,(ix+0)
        ld      b,(ix+1)
	ld	a,b
	and	a
	jr	z,flip1
	set	0,d
flip1:
	ld	a,c
	cp	$e8
	jr	z,flip2
	set	1,d
flip2:			; Do we need to set either colour or decoration?
	ld	a,d
	and	a
	jr	nz,flip3
			; Nothing mandatory, force colour
	set	1,d
flip3:

	; Do decoration first (if both colour and deco defined)
	bit	0,d
	jr	z,no_place_initial_deco
        ld      (hl),e
        inc     hl
        ld      (hl),b
        inc     hl
        inc     e
	exx
	dec	c
	exx
no_place_initial_deco:
	bit	1,d
	jr	z,no_place_initial_col
        ld      (hl),e
        inc     hl
        ld      (hl),c
        inc     hl
        inc     e       ;attribute column
        exx
        dec     c
        exx
no_place_initial_col:
        exx
        inc     ix
        inc     ix
        ; And loop over the remaining columns
compress_loop:
		; Have we filled all attributes?
        ld      a,c
        and     a
        ret     z       ;We have filled everything
	ld	a,b
	exx
	cp	e
	jr	c,noset_attr_x
	ld	e,a
noset_attr_x:
        ld      a,(ix+0)        ;Colour
        cp      c
        jp      z,no_place_colour
		; The colour changed, put it in position
        ld      c,a
        ld      (hl),e
        inc     hl
        ld      (hl),c
        inc     hl
        inc     e
        exx
        dec     c		;We've placed another attribute, dec space
        exx
no_place_colour:
        ld      a,(ix+1)
        cp      b
        jp      z,no_place_attr
        ld      b,a
        ld      (hl),e
        inc     hl
        ld      (hl),b
        inc     hl
        inc     e
        exx
        dec     c
        exx
no_place_attr:
        inc     ix
        inc     ix
        exx
	inc	b
	ld	a,b
	cp	80
	jr	nz,compress_loop
pad_buf:
        ld      a,c
        and     a
        ret     z
        exx
        ld      (hl),0x80
        inc     hl
        ld      (hl),0xe8
        inc     hl
        exx
        dec     c
        jr      pad_buf



	
	
	

generic_console_cls:
	ld	a,(__pc88_mode)
	and	a
	jr	z,__pc88_clear_text
__pc88_clear_hires:
	call	l_push_di
;IF ALU
	ld	a,__CLIB_PC8800_V2_ENABLED
	and	a
	jp	z,cls_v1_only
        ld      a,$80                   ;Turn on expanded gvram
        out     (EXPANDED_GVRAM_CTRL),a
        in      a,(ALU_MODE_CTRL)       ;Enable ALU
        set     6,a
        out     (ALU_MODE_CTRL),a
	ld	a,(__pc88_paper)
	out	(EXPANDED_ALU_CTRL),a
	ld	a,255
	call	clear_plane
        in      a,(ALU_MODE_CTRL)       ;Disable ALU
        res     6,a
        out     (ALU_MODE_CTRL),a
        ld      a,$00                   ;Turn off expanded gvram
        out     (EXPANDED_GVRAM_CTRL),a
	call	l_pop_ei
	ret
;ELSE
cls_v1_only:
	; Clear the hires planes
	xor	a
	out	(GVRAM_SEL_0),a		;Switch to green
	call	clear_plane
	out	(GVRAM_SEL_1),a		;Switch to red
	call	clear_plane
	out	(GVRAM_SEL_2),a		;Switch to blue
	call	clear_plane
	out	(MAINRAM_SEL),a		;Back to main memory
;ENDIF
	call	l_pop_ei
	ret

__pc88_clear_text:
	in	a,(ALU_MODE_CTRL)
	push	af
	res	4,a
	out	(ALU_MODE_CTRL),a
	; Clearing for text
	ld	hl, DISPLAY
	ld	c,25
cls_1:
	ld	b,80
cls_2:
	ld	(hl),0
	inc	hl
	djnz	cls_2
	call	clear_row_attribute
	dec	c
	jr	nz,cls_1
	pop	af
	out	(ALU_MODE_CTRL),a
	ret


clear_row_attribute:
	ld	b,20		;20 attributes
no_set_decoration:
	ld	(hl),0x80
	inc	hl
	ld	(hl),0xe8
	inc	hl
	djnz	no_set_decoration
	ret


clear_plane:
	ld	hl,$c000
	ld	de,$c001
	ld	bc,15999	;80x200 - 1
	ld	(hl),a
	ldir
	ret

; c = x
; b = y
; a = d = character to print
generic_console_plotc:
	in	a,(ALU_MODE_CTRL)
	push	af
	res	4,a
	out	(ALU_MODE_CTRL),a
	ld	a,d
	call	generic_console_scale
	push	bc
	call	xypos
	ld	(hl),a
	ld	a,(__pc88_textink)
	or	24
	ld	e,a
	ld	d,0
	pop	bc
	call	insert_attribute
	pop	af
	out	(ALU_MODE_CTRL),a
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	a,(__pc88_mode)
	cp	2
	jp	z,printc_MODE2
	push	de
	call	generic_console_scale
	push	bc
	call	xypos
	pop	bc	;coordinates back
	pop	de	;d = character to write
	in	a,(ALU_MODE_CTRL)
	push	af
	res	4,a
	out	(ALU_MODE_CTRL),a
	ld	(hl),d	;place character
	ld	de,(__pc88_textink)
	call	insert_attribute
	pop	af
	out	(ALU_MODE_CTRL),a
	ret


generic_console_pointxy:
	call	generic_console_vpeek_text
	and	a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__pc88_mode)
	cp	2
	jp	z,vpeek_MODE2
generic_console_vpeek_text:
	call	generic_console_scale
        call    xypos
	in	a,(ALU_MODE_CTRL)
	ld	c,a
	res	4,a
	out	(ALU_MODE_CTRL),a
	ld	d,(hl)
	ld	a,c
	out	(ALU_MODE_CTRL),a
	ld	a,d
	and	a
	ret


generic_console_scale:
        push    af
        ld      a,(__pc88_mode)
        cp      1
        jr      nz,no_scale
        sla     c               ;40 -> 80 column
no_scale:
        pop     af
        ret

; b = y
; c = x (scaled to 80 columns)
xypos_attr_row:
	ld	ix,DISPLAY-40
	ld	de,120
	inc	b
xypos_attr_1:
	add	ix,de
	djnz	xypos_attr_1
	ret


xypos:
	ld	hl,DISPLAY - 120
	ld	de,120
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret



generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__pc88_mode)
	cp	2
	jp	z,scrollup_MODE2
	in	a,(ALU_MODE_CTRL)
	push	af
	res	4,a
	out	(ALU_MODE_CTRL),a
	ld	hl, DISPLAY + 120
	ld	de, DISPLAY
	ld	bc, 120 * 24
	ldir
	ex	de,hl
	ld	b,80
generic_console_scrollup_3:
	ld	(hl),0
	inc	hl
	djnz	generic_console_scrollup_3
	inc	hl
	call	clear_row_attribute
	pop	af
	out	(ALU_MODE_CTRL),a
	pop	bc
	pop	de
	ret

	SECTION		bss_driver

expand_buf:	defs	160

	SECTION 	code_crt_init

	EXTERN	pc88_cursoroff

	call	pc88_cursoroff
	ld	hl,$E6B9
	res	1,(hl)
	ld	a,($E6C0)
	set	1,a
	ld	($E6C0),a
	ld	a,%00000001	;80 column, colour mode
	out	($30),a
