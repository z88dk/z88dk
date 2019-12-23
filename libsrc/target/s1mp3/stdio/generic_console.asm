
        SECTION         code_driver

        PUBLIC          generic_console_cls
        PUBLIC          generic_console_vpeek
        PUBLIC          generic_console_scrollup
        PUBLIC          generic_console_printc
        PUBLIC          generic_console_set_ink
        PUBLIC          generic_console_set_paper
        PUBLIC          generic_console_set_attribute

        EXTERN          LCD_UpdateScreen
        EXTERN          LCD_ClearScreen
       

        EXTERN          _Screen

        EXTERN          CONSOLE_ROWS
        EXTERN          CONSOLE_COLUMNS
        EXTERN          generic_console_font32

generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
    ret


generic_console_cls:
    call    LCD_ClearScreen
    call    LCD_UpdateScreen
    ret

generic_console_vpeek:
    scf
    ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    push    hl      ;buffer
    call    xypos
    pop     de      ;buffer
    push    hl		;Save screen address
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      bc,(generic_console_font32)
    add     hl,bc
    dec     h
    ; At this point, hl = font, de = buffer
    push    de
    ld      bc,8
    ldir            ;Copy font into the buffer 
    pop     hl      ;hl = buffer
    pop     de      ;Screen address
    ld      c,8
rotate0:
    push    hl
    ld      b,8
rotate1:
    rl      (hl)        ;font
    ld      a,(de)      ;screen
    rra
    ld      (de),a
    inc     hl
    djnz    rotate1
    inc     de
    inc     de
    inc     de
    inc     de
    pop     hl
    dec     c
    jr      nz,rotate0
    ld      hl,8        ;Restore stack
    add     hl,sp
    ld      sp,hl
   ;call    LCD_UpdateScreen
    ret


; c = x
; b = y
xypos:
	ld	hl,-(CONSOLE_ROWS * 8)
	ld	de,+(CONSOLE_ROWS * 8)
	inc	c
xypos_1:
	add	hl,de
	dec	c
	jr	nz,xypos_1
	ld	c,b
	ld	b,0
    add hl,bc
    ld      bc,(_Screen)
    add     hl,bc
	ret

generic_console_scrollup:
    ret
