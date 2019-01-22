
	SECTION		code_clib

	PUBLIC		generic_console_vpeek

        EXTERN          vpeek_screendollar
	EXTERN		generic_console_xypos_graphics
        EXTERN          screendollar
        EXTERN          screendollar_with_count
        EXTERN          generic_console_font32
        EXTERN          generic_console_udg32


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        ld      hl,-8
        add     hl,sp           ;de = screen, hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
	push	hl
	call	generic_console_xypos_graphics
	pop	de

        ld      b,8
vpeek_1:
	ld	a,(hl)
	; Reverse
        ld      c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
        rrc     c
        xor     c
        and     0x66
        xor     c
	ld	(de),a
	inc	de
	ld	a,l
	add	30
	ld	l,a
	jr	nc,no_overflow
	inc	h
no_overflow:
	djnz	vpeek_1
vpeek_screendollar:
        pop     de              ;the buffer on the stack
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af           ; Save those flags
        ld      hl,8            ; Dump our temporary buffer
        add     hl,sp
        ld      sp,hl
        ex      af,af           ; Flags and parameter back
        ret
