

		SECTION		code_clib

		PUBLIC		__tms9918_cls
		PUBLIC		__tms9918_scrollup
		PUBLIC		__tms9918_printc
                PUBLIC          __tms9918_set_ink
                PUBLIC          __tms9918_set_paper
                PUBLIC          __tms9918_set_inverse
		EXTERN		msx_attr

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32

		EXTERN		tms9918_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
        	EXTERN		msxbios
		EXTERN		ansi_SCROLLUP
		EXTERN		ansi_cls
		EXTERN		conio_map_colour
		EXTERN		CRT_FONT
		EXTERN		generic_console_flags

IF FORmsx
	        INCLUDE "target/msx/def/msxbios.def"
ELSE
        	INCLUDE "target/svi/def/svibios.def"
ENDIF


;
; The SPC-1000 has both a MC6847 and optionally a TMS9228A
;
; To support both we want the MC6847 to be the primary, and
; the VDP as the slave, so don't export the tms symbols as
; generic_console_*
;
IF !FORspc1000
                PUBLIC          generic_console_cls
                PUBLIC          generic_console_scrollup
                PUBLIC          generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		defc	generic_console_cls = __tms9918_cls
		defc	generic_console_scrollup = __tms9918_scrollup
		defc	generic_console_printc = __tms9918_printc
		defc	generic_console_set_ink = __tms9918_set_ink
		defc	generic_console_set_paper = __tms9918_set_paper
		defc	generic_console_set_inverse = __tms9918_set_inverse
ENDIF


__tms9918_set_inverse:
	ret

__tms9918_set_ink:
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

__tms9918_set_paper:
	call	conio_map_colour
	ld	b,0xf0
	jr	set_attr
	

__tms9918_cls:
	call	ansi_cls
	ret

__tms9918_scrollup:
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
__tms9918_printc:
	push	ix
	rl	e
	jr	c,tms9918_printc_1
	; Here we can interpret any extra codes (eg for setting colours)

tms9918_printc_1:
	bit	7,a
	jr	nz,tms9918_printc_handle_udgs
	sub	32
	ld	de,(generic_console_font32)
tms9918_printc_rejoin:
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
	push	hl
	ld	a,(msx_attr)
	ld	hl,generic_console_flags
	bit	7,(hl)
	jr	z,not_inverse
	rlca
	rlca
	rlca
	rlca
not_inverse:
	pop	hl
	ld	bc,8
	ld	ix,FILVRM
	call	msxbios
	pop	ix
	ret

tms9918_printc_handle_udgs:
	sub	128
	ld	de,(generic_console_udg32)
	jr	tms9918_printc_rejoin

