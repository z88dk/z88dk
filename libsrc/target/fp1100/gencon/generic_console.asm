;
; We keep a mirrored screen at 0x9000 - 80x24
;
;
;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		__console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour

		defc		DISPLAY = 0x9000

		INCLUDE		"target/fp1100/def/fp1100.def"
		INCLUDE		"ioctl.def"

generic_console_ioctl:
        ex      de,hl
        ld      c,(hl)  ;bc = where we point to
        inc     hl
        ld      b,(hl)
	cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
	ld	a,c
	ld	b,2
	ld	c,40
	and	a
	jr	z,setmode
	ld	b,1
	ld	c,80
	dec	a
	jr	z,setmode
failure:
	scf
	ret

setmode:
	ld	a,c
	ld	(__console_w),a
	ld	a,SUB_SCREENSIZE
	call	TRNC2
	and	a
	ret

generic_console_set_inverse:
	ld	a,(__inverse)
	ld	b,a
	ld	a,0
	bit	7,(hl)
	jr	z,inverse_off
	inc	a
inverse_off:
	cp	b
	ret	z		;No change to inverse
	ld	(__inverse),a
	ld	a,(__attr)
	rrca
	rrca
	rrca
	rrca
	ld	(__attr),a
	jr	set_colour

generic_console_set_ink:
	call	conio_map_colour
	and	7
	ld	b,a
	ld	a,(__attr)
	and	@01110000
	or	b
	ld	(__attr),a
set_colour:
	ld	bc,(__attr)
	ld	a,SUB_COLOUR
	call	TRNC3
	ret

generic_console_set_paper:
	call	conio_map_colour
	rlca
	rlca
	rlca
	rlca
	and	@01110000
	ld	b,a
	ld	a,(__attr)
	and	@00000111
	or	b
	ld	(__attr),a
	jr	set_colour

generic_console_cls:
	ld	a,SUB_CLS
	call	TRNC1
	ld	hl,DISPLAY
	ld	de,DISPLAY + 1
	ld	bc, 80 * 24 - 1
	ld	(hl),0
	ldir
	ret

generic_console_scrollup:
	push	de
	push	bc
	ld	a,SUB_SCROLLUP
	call	TRNC1
        ld      hl, DISPLAY + 80
        ld      de, DISPLAY
        ld      bc, 80 * 23
        ldir
        ex      de,hl
        ld      b,80
generic_console_scrollup_3:
        ld      (hl),32
        inc     hl
        djnz    generic_console_scrollup_3
	pop	bc
	pop	de
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	push	bc
	call	generic_console_xypos
	ld	(hl),a
	pop	bc
	push	af
	ld	hl,__lastxy
	ld	a,(hl)
	inc	a
	cp	c
	jr	nz,set_position
	inc	hl
	ld	a,(hl)
	cp	b
	jr	z,skip_position
set_position:
	ld	(__lastxy),bc
	ld	a,SUB_SETXY
	call	TRNC3
skip_position:
	pop	af
	ld	b,a
	ld	a,SUB_PRINTCHAR
	call	TRNC2
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	call	generic_console_xypos
	ld	a,(hl)
	and	a
	ret

generic_console_xypos:
        ld      hl, DISPLAY - 80
        ld      de,80
        inc     b
generic_console_printc_1:
        add     hl,de
        djnz    generic_console_printc_1
generic_console_printc_3:
        add     hl,bc                   ;hl now points to address in display
        ret


	SECTION		data_clib

__attr:		defb	0x07
		defb	0x00

	SECTION		bss_clib
__lastxy:	defw	-1
__inverse:	defb	0
