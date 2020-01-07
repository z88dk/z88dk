

                SECTION         code_clib

                PUBLIC          generic_console_cls
                PUBLIC          generic_console_printc
                PUBLIC          generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute


                EXTERN          CONSOLE_COLUMNS
                EXTERN          CONSOLE_ROWS

                EXTERN          generic_console_font32
                EXTERN          generic_console_udg32
		EXTERN		generic_console_flags

                defc            DISPLAY = 0xc000

generic_console_set_paper:
generic_console_set_attribute:
generic_console_set_ink:
        ret


generic_console_scrollup:
	push	bc
	push	de
	pop	de
	pop	bc
	ret

generic_console_cls:
	ld	hl,DISPLAY
	ld	bc,16384
cls_loop:
	ld	(hl),0
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,cls_loop
	ret


generic_console_printc:
        ld      e,d
        ld      d,0
        ld      a,e
        ld      hl,(generic_console_font32)
        rlca
        jr      nc,not_udg
        ccf
        rrca
        ld      e,d
        ld      hl,(generic_console_udg32)
        inc     h               ;We decrement later
not_udg:
        ex      de,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        dec     h               ; -32 characters
        ex      de,hl           ; de = font
	call	xypos

        ld      a,(generic_console_flags)
        rlca
        sbc     a,a
        ld      c,a             ;x = 0 / 255
	ld	b,8
loop:
	push	bc
	ld	a,(de)
	xor	c		;Handle inverse
				;Now, mirror bits
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
        ld      b,a
        ld      a,c
        rrca
        ld      c,a
        ld      a,b
        xor     c
        and     0x66
        xor     c
	rrca
	and	@00111111
	ld	(hl),a
	inc	de
	ld	bc,64		;Move to next row
	add	hl,bc
	pop	bc
	djnz	loop
	ret


; Entry: b = row
;	 c = column
; Exit:	hl = address
xypos:
	; 512 bytes per row
	ld	h,b		;* 256
	ld	l,0
	add	hl,hl
	ld	b,+(DISPLAY / 256)
	add	hl,bc
	ret

	ret

