

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		EXTERN		msx_attr
		PUBLIC		__msx_font32
		PUBLIC		__msx_udg32

		EXTERN		generic_console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
        	EXTERN		msxbios
		EXTERN		ansi_SCROLLUP
		EXTERN		ansi_cls
		EXTERN		conio_map_colour
		EXTERN		CRT_FONT

IF FORmsx
	        INCLUDE "target/msx/def/msxbios.def"
ELSE
        	INCLUDE "target/svi/def/svibios.def"
ENDIF


generic_console_set_inverse:
	ret

generic_console_set_ink:
	call	conio_map_colour
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
	call	conio_map_colour
	ld	b,0xf0
	jr	set_attr
	

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

;  V-RAM memory map TMS9918 so address can be changed but it is the address when initializing with BASIC system Graphic mode 2 (SCREEN 2 in MSX) is used 00000 H - 007 FFH: Pattern generator top 00800 H -00FFFH: pattern generator middle 01000H - 017FFH: pattern generator low 01800H - 01BFFH: sprite pattern generator 01C00H - 01F7FH: pattern name table 01F00H - 01FFFH: sprite attribute 02000H - 03FFFH: color table　


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
	bit	7,a
	jr	nz,generic_console_printc_handle_udgs
	sub	32
	ld	de,(__msx_font32)
generic_console_printc_rejoin:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
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

generic_console_printc_handle_udgs:
	sub	128
	ld	de,(__msx_udg32)
	jr	generic_console_printc_rejoin


		SECTION	data_clib
.__msx_font32	defw    CRT_FONT
.__msx_udg32	defw    0
