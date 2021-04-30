;
; The Multi8 can operate in multiple modes
;
; - Text/character based - 40x25, 80x25 there's attributes there as well
; - Full RGB - they actually end up being superimposed on each other (when in text mode)
;
;
; Text mode = two bytes get written 2k apart
;

    ; In code_driver so we are low down in memory and hopefully
    ; never paged out
    SECTION code_driver

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  generic_console_xypos_graphics
    PUBLIC  generic_console_xypos
    PUBLIC  generic_console_scale
    EXTERN  printc_MODE2

    EXTERN  conio_map_colour
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    EXTERN  l_push_di
    EXTERN  l_pop_ei

    EXTERN  CRT_FONT
    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  __vram_in
    EXTERN  __vram_out
    EXTERN  __port29_copy
    EXTERN  __multi8_mode
    EXTERN  __multi8_ink
    EXTERN  __multi8_paper

    defc    DISPLAY = 0x8000

generic_console_set_ink:
    call    conio_map_colour
    and     7
    ld      (__multi8_ink),a
    ld      b,a
    ld      a,(__multi8_attr)
    and     248
    or      b
    ld      (__multi8_attr),a
    ret

    
generic_console_set_paper:
    call    conio_map_colour
    and     7
    ld      (__multi8_paper),a
    ret

generic_console_set_attribute:
    ld      a,(__multi8_attr)
    and      0xdf
    bit     7,(hl)
    jr      z,store
    or      0x20
store:
    ld      (__multi8_attr),a
    ret

generic_console_cls:
    call    l_push_di
    ld      a,(__vram_in)    ;Clear hires screens
    and     @11110000
    or      @00001000
    out     ($2a),a
    ld      hl,DISPLAY
    ld      de,DISPLAY + 1
    ld      bc, 16383
    ld      (hl),0
    ldir
    and     @11110000    ;And clear text screen
    or      @00000111
    out     ($2a),a
    ld      hl, DISPLAY
    ld      de, DISPLAY +1
    ld      bc, 80 * 25 - 1
    ld      (hl),32
    ldir
    ld      hl, DISPLAY + 0x800
    ld      de, DISPLAY + 0x800 + 1
    ld      bc, 80 * 25 - 1
    ld      a,(__multi8_attr)
    ld      (hl),a
    ldir
    ld      a,(__vram_out)
    out     ($2a),a
    call    l_pop_ei
    ret


generic_console_scale:
    push    af
    ld      a,(__multi8_mode)
    cp      1
    jr      z,no_scale
    sla     c    ;40 -> 80 column
no_scale:
    pop     af
    ret
    

; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
    ld      a,(__multi8_mode)
    cp      2
    jp      z, printc_MODE2
    ld      a,d
    call    generic_console_scale
    call    generic_console_xypos
    ld      e,a
    call    l_push_di
    ld      a,(__vram_in)
    out     ($2a),a
    ld      (hl),e
    ld      bc,0x800
    add     hl,bc
    ld      a,(__multi8_attr)
    ld      (hl),a
printc_exit:
    ld      a,(__vram_out)
    out     ($2a),a
    call    l_pop_ei
    ret



generic_console_xypos:
    ld      hl, DISPLAY - 80
    ld      de,80
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc        ;hl now points to address in display
    ret




generic_console_scrollup:
    push    de
    push    bc
    call    l_push_di
    ld      a,(__multi8_mode)
    cp      2
    ld      a,(__vram_in)
    jr      z,scrollup_graphics
    out     ($2a),a
    ld      hl, DISPLAY + 80
    ld      de, DISPLAY
    ld      bc, 80 * 24
    ldir
    ex      de,hl
    ld      b,80
generic_console_scrollup_3:
    ld      (hl),32
    inc     hl
    djnz    generic_console_scrollup_3
    ld      hl, DISPLAY + 0x800 + 80
    ld      de, DISPLAY + 0x800
    ld      bc,80 * 24
    ldir
    ; blank out last row
    ex      de,hl
    ld      b,80
    ld      a,(__multi8_attr)
generic_console_scrollup_4:
    ld      (hl),a
    inc     hl
    djnz    generic_console_scrollup_4
scrollup_exit:
    ld      a,(__vram_out)
    out     ($2a),a
    call    l_pop_ei
    pop     bc
    pop     de
    ret

scrollup_graphics:
    or      @00000110
    call    scroll_gfx
    ld      a,(__vram_in)
    or      @00000101
    call    scroll_gfx
    ld      a,(__vram_in)
    or      @00000011
    call    scroll_gfx
    jr      scrollup_exit
scroll_gfx:
    out     ($2a),a
    ld      hl, DISPLAY + 80 * 8
    ld      de, DISPLAY
    ld      bc, 80 * 192
    ldir
    ex      de,hl
    ld      d,h
    ld      e,l
    inc     de
    ld      (hl),0
    ld      bc, 80 * 8
    ldir
    ret



    SECTION    data_clib

__multi8_attr:
    defb    0x07    ;white ink


    SECTION    code_crt_init

    ; Enable colour text mode
    ld      a,(__port29_copy)
    and     127
    ld      (__port29_copy),a
    out     ($29),a
    ; Make the display 25 lines in height
    ; Write 25 to register 6 of CTC
    ; Write 7 to register 9 of CTC to set font height
    ld      a,6
    out     ($1c),a
    ld      a,25
    out     ($1d),a
    ld      a,9
    out     ($1c),a
    ld      a,7
    out     ($1d),a
 