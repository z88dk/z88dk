
	SECTION		code_clib
	PUBLIC		printc_MODE1

	EXTERN		generic_console_udg32
	EXTERN		generic_console_font32
        EXTERN          generic_console_flags


	INCLUDE		"target/pc6001/def/pc6001.def"

; c = x
; b = y
; a' = d = character to print
; e = raw
printc_MODE1:
        ld      l,d
        ld      h,0
        ld      de,(generic_console_font32)
        bit     7,l
        jr      z,not_udg
        res     7,l
        ld      de,(generic_console_udg32)
        inc     d
not_udg:
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        dec     h
        ex      de,hl           ;de = font
        ld      h,b             ;32 * 8
        ld      l,c
        ld      bc,(SYSVAR_screen - 1)
        ld      c,0
        add     hl,bc
        inc     h
        inc     h               ;hl = screen address
	ld	a,(generic_console_flags)
	ld	b,a		;Save flags
	rrca
        sbc     a,a
        ld      c,a             ;x = 0 / 255
	ex	de,hl		;hl = font, de screen
        ld      a,8
hires_printc_1:
	ex	af,af
        ld      a,(hl)
	bit	4,b
	jr	z,no_bold
	rrca
	or	(hl)
no_bold:
        xor     c	;Inverse
        ld      (de),a
        inc     hl
        ld      a,e
        add     32
        ld      e,a
        jr      nc,no_overflow
        inc     d
no_overflow:
	ex	af,af
	dec	a
	jr	nz,hires_printc_1
	bit	3,b		;Check underline
	ret	z
	ex	de,hl		;hl is now screen
	ld	bc,-32
	add	hl,bc
	ld	(hl),255
        ret
