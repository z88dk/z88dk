
	SECTION		code_clib
	PUBLIC		printc_MODE2

	EXTERN		generic_console_udg32
	EXTERN		generic_console_font32
	EXTERN		generic_console_flags
	EXTERN		__MODE2_attr
        EXTERN          __pc6001_attr
        EXTERN          __pc6001_mode
	EXTERN		generic_console_text_xypos


	INCLUDE		"target/pc6001/def/pc6001.def"

; c = x
; b = y
; a' = d = character to print
; e = raw
printc_MODE2:
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
        ld      bc,(SYSVAR_screen - 1)
        ld      c,l
        add     hl,bc
        inc     h
        inc     h               ;hl = screen address
        ld      a,(__pc6001_attr)
        rrca
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
        ld      (hl),c
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
IF setCSSoneachchar
	; This isn't working yet, not sure if it ever will - set the
	; CSS flag for each character, this has slightly odd effects
	; since we end up mapping a character into 4 blocks
	sla	c		;column * 2
	ld	a,b
	add	a		;row * 8
	add	a
	add	a
	ld	b,0
div12:	sub	12
	jr	c,div12_done
	inc	b
	jr	div12

div12_done:
	call	generic_console_text_xypos
	dec	h
	dec	h
	ld	a,(__pc6001_attr)
	and	@00000010
	ld	c,a
	ld	a,(hl)
	and	@11111101
	or	c
	ld	(hl),a
	inc	hl
;	ld	(hl),a
	ld	de,31
	add	hl,de
	ld	(hl),a
	inc	hl
;	ld	(hl),a
ENDIF
	ret
