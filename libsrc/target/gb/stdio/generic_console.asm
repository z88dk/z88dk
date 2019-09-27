

                SECTION         code_driver

                PUBLIC          generic_console_cls
                PUBLIC          generic_console_vpeek
                PUBLIC          generic_console_scrollup
                PUBLIC          generic_console_printc
                PUBLIC          generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		GLOBAL		asm_setchar
		GLOBAL		scroll
		GLOBAL		cls

		INCLUDE "target/gb/def/gb_globals.def"

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

generic_console_ioctl:
        scf
generic_console_set_inverse:
generic_console_set_ink:
generic_console_set_paper:
        ret


generic_console_cls:
	jp	cls


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        ld      a,b	      ; Y coordinate
        ld      l,a
        ld      h,0x00
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        ld      c,a
        ld      b,0x00
        add     hl,bc
        ld      bc,0x9800
        add     hl,bc
vpeek_1:
	ldh	a,(STAT)
	bit	1,a
	jr	nz,vpeek_1
	ld	a,(hl)
	and	a
	ret



; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	jp	asm_setchar

generic_console_scrollup:
	push	de
	push	bc
	call	scroll
	pop	bc
	pop	de
	ret

