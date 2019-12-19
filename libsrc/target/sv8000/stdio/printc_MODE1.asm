
	SECTION		code_clib
	PUBLIC		printc_MODE1

	EXTERN		generic_console_udg32
	EXTERN		generic_console_font32
        EXTERN          generic_console_flags


	INCLUDE		"target/sv8000/def/sv8000.def"

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
        ld      bc,DISPLAY
        add     hl,bc
	ld	a,(generic_console_flags)
	rlca
        sbc     a,a
        ld      c,a             ;x = 0 / 255
        ld      b,8
hires_printc_1:
        ld      a,(de)
        xor     c
        ld      (hl),a
        inc     de
        ld      a,l
        add     32
        ld      l,a
        jr      nc,no_overflow
        inc     h
no_overflow:
        djnz    hires_printc_1
        ret
