
	SECTION		code_clib
	PUBLIC		printc_MODE2

	EXTERN		generic_console_udg32
	EXTERN		generic_console_font32
	EXTERN		generic_console_flags
	EXTERN		__MODE2_attr
	EXTERN		__mc1000_modeval

        defc            DISPLAY = 0x8000


; c = x
; b = y
; a' = d = character to print
; e = raw
printc_MODE2:
	ld	a,(__mc1000_modeval)
	ex	af,af
	push	bc
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
        ld      b,+(DISPLAY / 256)
        add     hl,bc
        ld      a,(generic_console_flags)
        rlca
        sbc     a,a
        ld      c,a             ;x = 0 / 255
        ld      b,8
semihires_1:
        push    bc
        ld      a,(de)
        xor     c
        push    de
        ld      b,2
semihires_2:
        ld      de,(__MODE2_attr)
        push    bc
        push    hl
        ld      l,a
        ld      b,4
        ld      c,0     ;final attribute
semihires_3:
        rl      l
        ld      a,d
        jr      nc,is_paper
        ld      a,e
is_paper:
        or      c
        ld      c,a
        srl     d
        srl     d
        srl     e
        srl     e
        djnz    semihires_3
        ld      a,l             ;save what's left of character
        pop     hl
	ex	af,af
	res	0,a
	out	($80),a		;Page VRAM in
        ld      (hl),c
	set	0,a
	out	($80),a		;VRAM out
	ex	af,af
        inc     hl
        pop     bc
        djnz    semihires_2
        ld      de,30
        add     hl,de
        pop     de
        inc     de
        pop     bc
        djnz    semihires_1
	pop	bc		;need to convert to appropriate coordinate
	ret
