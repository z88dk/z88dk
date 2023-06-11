

    SECTION     code_clib

    PUBLIC      generic_console_vpeek
    PUBLIC      generic_console_printc
    PUBLIC      generic_console_scrollup
    PUBLIC      generic_console_set_ink
    PUBLIC      generic_console_set_paper
    PUBLIC      generic_console_set_attribute
    PUBLIC      generic_console_pointxy
    PUBLIC      generic_console_plotc

    EXTERN      printc_MODE1
    EXTERN      vpeek_MODE1

    EXTERN      mc6847_map_colour
    EXTERN      __MODE1_attr
    EXTERN      CONSOLE_COLUMNS
    EXTERN      CONSOLE_ROWS
    EXTERN      base_graphics
    EXTERN      __vz200_mode


generic_console_set_paper:
    call    mc6847_map_colour
    ld      a,b
    rrca
    rrca
    and	    @11000000
    ld      (__MODE1_attr+1),a
generic_console_set_attribute:
    ret

generic_console_set_ink:
    call    mc6847_map_colour
    ld      a,b
    rlca
    rlca
    rlca
    rlca
    or      128
    and     @11110000
    ld      (colour_mask),a
    ld      a,b
    rrca
    rrca
    and     @11000000
    ld      (__MODE1_attr),a
    ret



; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
    ld      e,1
generic_console_printc:
    ld      d,a
    ld      a,(__vz200_mode)
    and     a
    jp      nz,printc_MODE1
    ld      a,d
    push    de
    call    xypos
    pop     de
    rr      e
    call    nc,convert_character
    cp      128
    jr      c,place_character
    and     @10001111
    ld      c,a
    ld      a,(colour_mask)
    or      c
place_character:
    ld      (hl),a
    ret


generic_console_pointxy:
    call    generic_console_vpeek
    and     @10001111
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      a,(__vz200_mode)
    and     a
    jp      nz,vpeek_MODE1
    call    xypos
    ld      a,(hl)
    and     a
    ret



xypos:
    ld      l,b
    ld      h,0
    add     hl,hl       ;*32
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      b,0
    add     hl,bc
    ld      bc,(base_graphics)
    add     hl,bc
    ret


convert_character:
    cp      97
    jr      c,isupper
    sub     32
.isupper
    and     @00111111
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld      a,(__vz200_mode)
    and     a
    jr      nz,scrollup_MODE1
    ld      hl, (base_graphics)
    ld      d,h
    ld      e,l
    ld      bc, CONSOLE_COLUMNS
    add     hl,bc
    ld      bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
    ldir
    ex      de,hl
    ld      b,CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl),32
    inc     hl
    djnz    generic_console_scrollup_3
    pop     bc
    pop     de
    ret

scrollup_MODE1:
    ld      hl, (base_graphics)
    ld      d,h
    ld      e,l
    inc     h
    ld      bc, 2048 - 256
    ldir
    ex      de,hl
    ld      d,h
    ld      e,l
    inc     de
    ld      bc,255
    ld      (hl),0
    ldir
    pop     bc
    pop     de
    ret

	SECTION	bss_clib

colour_mask:	defb	0
