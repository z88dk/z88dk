

    MODULE  generic_console
    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_xypos

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    EXTERN  generic_console_flags

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out


    EXTERN  NC_VRAM
    EXTERN  NC_VRAM_YSIZE


generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
    ret

generic_console_scrollup:
    push    de
    push    bc
    call    __gfx_vram_page_in
    ld      hl, +(NC_VRAM+(64*8))
    ld      de, NC_VRAM
    ld      bc, +((NC_VRAM_YSIZE-8) * 64)
    ldir
    ex      de, hl
    ld      d, h
    ld      e, l
    inc     de
    ld      bc, +(64*8)-1
    ld      (hl), 0
    ldir
    call    __gfx_vram_page_out
    pop     bc
    pop     de
    ret


generic_console_cls:
    call    __gfx_vram_page_in
    ld      hl, NC_VRAM
    ld      de, NC_VRAM+1
    ld      bc, +(64 * NC_VRAM_YSIZE)-1
    ld      (hl), 0x00
    ldir
    call    __gfx_vram_page_out
    ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    ld      de, (generic_console_font32)
    dec     d
    bit     7, a
    jr      z, printc_rejoin
    ld      de, (generic_console_udg32)
    res     7, a
printc_rejoin:
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de
    ex      de, hl                      ;de = font
    call    generic_console_xypos       ;-> hl = screen

    call    __gfx_vram_page_in

    ld      a, (generic_console_flags)
    rlca
    sbc     a
    ld      c, a                        ;c = 0 / c = 255
    ld      b, 8
printc_hires_loop:
    push    bc
    ld      a, (generic_console_flags)
    bit     4, a                        ;Bold
    ld      a, (de)
    jr      z, not_bold
    ld      b, a
    rrca
    or      b
not_bold:
    xor     c
    ld      (hl), a
    ld      bc, 64
    add     hl, bc
    inc     de
    pop     bc
    djnz    printc_hires_loop
	; And deal with underline
    ld      a, (generic_console_flags)
    bit     3, a
    jr      z,finished
    ld      bc, -64
    add     hl, bc
    ld      (hl), 255
finished:
    call    __gfx_vram_page_in
    ret


; Entry:
; c = x
; b = y
; Exit:
; hl = screen address
generic_console_xypos:
    ld      l, b
    ld      h, 0
    add     hl,hl			;*2
    add     hl,hl			;*4
    add     hl,hl			;*8
    add     hl,hl			;*16
    add     hl,hl			;*32
    add     hl,hl			;*64
    add     hl,hl			;*128
    add     hl,hl			;*256
    add     hl,hl			;*512
    ld      b, +(NC_VRAM / 256)
    add     hl, bc
    ret
