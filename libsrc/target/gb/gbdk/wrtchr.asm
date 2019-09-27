
	SECTION	code_driver

	PUBLIC	wrtchr
	PUBLIC	_wrtchr

	GLOBAL	__mode
	GLOBAL	asm_wrtchr
	GLOBAL	asm_adv_curs
	GLOBAL	gmode

	GLOBAL	generic_console_font32
	GLOBAL	generic_console_udg32
	GLOBAL	generic_console_256font

        INCLUDE "target/gb/def/gb_globals.def"
	


; void __LIB__    wrtchr(char chr);
wrtchr:
_wrtchr:                        ; Banked
        PUSH    BC

        LD      A,(__mode)
        CP      G_MODE
        CALL    NZ,gmode

        LD      HL,sp+4
        LD      C,(HL)		;character
	; We support:
	; gb_console_256font_32:	- 256 character font
	; generic_console_font32:	- standard 32-127 font as used elsewhere
	; generic_consoel_udg32:	- for udgs
	ld	hl,generic_console_256font
	ld	a,(hl+)
	or	(hl)
	jr	z,try_gencon_fonts
	ld	a,(hl-)
	ld	l,(hl)
	ld	h,a
	jr	do_print
try_gencon_fonts:
	ld	a,c
	cp	128
	jr	c,not_udg
	sub	128
	ld	c,a
	ld	hl,generic_console_udg32
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	jr	do_print
not_udg:
	ld	hl,generic_console_font32
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	dec	h		;Since font starts from character 32
do_print:
        CALL    asm_wrtchr
        CALL    asm_adv_curs

        POP     BC
        RET

