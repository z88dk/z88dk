

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		msx_attr
		PUBLIC		__msx_font32

		EXTERN		generic_console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
        	EXTERN		msxbios
		EXTERN		ansi_SCROLLUP
		EXTERN		ansi_cls
		EXTERN		CRT_FONT

IF FORmsx
	        INCLUDE "target/msx/def/msxbios.def"
ELSE
        	INCLUDE "target/svi/def/svibios.def"
ENDIF


generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_ink:
	call	map_colour
	rla
	rla
	rla
	rla
	ld	b,0x0f
set_attr:
	ld	c,a
	ld	hl,msx_attr
	ld	a,(hl)
	and	b
	or	c
	ld	(hl),a
	ret

generic_console_set_paper:
	call	map_colour
	ld	b,0xf0
	jr	set_attr
	

map_colour:
	and	7
	inc	a	;(1,3,5,7: black, green, blue, cyan)
	bit	0,a
	ret	nz
	add	7	; (2,4,6,8 -> 9,11,13,15; red, yellow, magenta, white)
	ret


generic_console_cls:
	call	ansi_cls
	ret

generic_console_scrollup:
	push	de
	push	bc
	call	ansi_SCROLLUP
	pop	bc
	pop	de
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	push	ix
	rl	e
	jr	c,generic_console_printc_1
	; Here we can interpret any extra codes (eg for setting colours)

generic_console_printc_1:
	sub	32
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	de,(__msx_font32)
	add	hl,de
	ld	a,c
	add	a
	add	a
	add	a
	ld	e,a
	ld	d,b
	push	de
	ld	ix,LDIRVM
	ld	bc,8
	call	msxbios
	pop	hl
	ld	de,8192
	add	hl,de	
	ld	a,(msx_attr)
	ld	bc,8
	ld	ix,FILVRM
	call	msxbios
	pop	ix
	ret


		SECTION	data_clib
.__msx_font32       defw    CRT_FONT
.msx_attr	defb $F1	; White on Black
