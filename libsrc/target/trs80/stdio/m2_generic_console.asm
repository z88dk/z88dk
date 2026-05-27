

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_ioctl
    PUBLIC  generic_console_set_attribute

    PUBLIC      generic_console_plotc
    PUBLIC      generic_console_pointxy

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    EXTERN  base_graphics

    INCLUDE     "ioctl.def"
    PUBLIC      CLIB_GENCON_CAPS
    defc        CLIB_GENCON_CAPS = CAP_GENCON_INVERSE

    defc    CHAR_TABLE=0xF800


generic_console_ioctl:
    scf
generic_console_set_ink:
    ret

generic_console_set_paper:
generic_console_set_attribute:
    rra
    ld      a,0
    jr      nc, noinv
    ld      a,128
noinv:
    ld      (m2_attribute),a
    ret

generic_console_cls:
    call    __gfx_vram_page_in
    ld      hl, (base_graphics)
    ld      d, h
    ld      e, l
    inc     de
    ld      bc, 1919
    ld      (hl), 32
    ldir
    jp      __gfx_vram_page_out


generic_console_plotc:
    call    xypos
    call    __gfx_vram_page_in
    ld      (hl), a
    jp      __gfx_vram_page_out

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    call    xypos

    rr      e
    jr      c, rawmode

    ld      d, a
    ld      a,(m2_attribute)
    add     d

rawmode:
    call    __gfx_vram_page_in
    ld      (hl), a
    jp      __gfx_vram_page_out


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
    call    xypos
    call    __gfx_vram_page_in
    ld      a, (hl)
    call    __gfx_vram_page_out
    and     a
    ret

generic_console_vpeek:
    call    xypos
    call    __gfx_vram_page_in
    ld      a, (hl)
    call    __gfx_vram_page_out
    rr      e
    call    nc, vpeek_unmap
    and     a
    ret

vpeek_unmap:
    cp      160
    ret     c
    and     $7f
    ret


xypos:
    push    de
    ld      hl, (base_graphics)
    ld      de, CONSOLE_COLUMNS
    inc     b
	and     a
    sbc     hl, de
generic_console_printc_1:
    add     hl, de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl, bc                      ;hl now points to address in display
	pop     de
    ret


generic_console_scrollup:
    ;push    de
    ;push    bc
    call    __gfx_vram_page_in
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
    call    __gfx_vram_page_out
    ;pop     bc
    ;pop     de
    ret

    SECTION bss_clib
m2_attribute:
    defb    0



    SECTION code_crt_init

    EXTERN  asm_set_cursor_state

;    ld      l, 0x20                     ;disable cursor
;    call    asm_set_cursor_state

;    SECTION code_crt_exit
;    EXTERN  __console_x
;    ld      bc, (__console_x)
;    call    xypos
;    ld      ($4020), hl
