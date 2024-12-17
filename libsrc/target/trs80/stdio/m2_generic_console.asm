

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

    EXTERN  base_graphics

    defc    CHAR_TABLE=0xF800


generic_console_set_ink:
    ret

generic_console_set_paper:
generic_console_set_attribute:
    ret

generic_console_cls:
    call    swapgfxbk
    ld      hl, (base_graphics)
    ld      d, h
    ld      e, l
    inc     de
    ld      bc, 1919
    ld      (hl), 32
    ldir
    jp      swapgfxbk1

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    push    de
    call    xypos
    pop     de
    ld      d, a
    call    swapgfxbk
    ld      (hl), d
    jp      swapgfxbk1


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      a, e
    call    xypos
    ld      e, a
	push    de
    call    swapgfxbk
	pop     de
    ld      d, (hl)
	push    de
    call    swapgfxbk1
	pop     de
    rr      e
    call    nc, vpeek_unmap
    ld      a, d
    and     a
    ret

vpeek_unmap:
    ld      a, d
    cp      160
    ret     c
    res     7, d
    ret

xypos:
    ld      hl, (base_graphics)
    ld      de, CONSOLE_COLUMNS
    inc     b
    sbc     hl, de
generic_console_printc_1:
    add     hl, de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl, bc                      ;hl now points to address in display
    ret


generic_console_scrollup:
    push    de
    push    bc
    call    swapgfxbk
    ld      hl, CONSOLE_COLUMNS
    ld      de, (base_graphics)
    add     hl, de
    ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3
    call    swapgfxbk1
    pop     bc
    pop     de
    ret

    SECTION bss_clib


    SECTION code_crt_init

    EXTERN  asm_set_cursor_state

;    ld      l, 0x20                     ;disable cursor
;    call    asm_set_cursor_state

;    SECTION code_crt_exit
;    EXTERN  __console_x
;    ld      bc, (__console_x)
;    call    xypos
;    ld      ($4020), hl
