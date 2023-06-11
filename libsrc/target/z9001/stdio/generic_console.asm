;
;

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  __z9001_attr
    EXTERN  __z9001_mode
    EXTERN  conio_map_colour
    EXTERN  generic_console_flags

    EXTERN  printc_MODE1
    EXTERN  vpeek_MODE1
    EXTERN  cls_MODE1
    EXTERN  scrollup_MODE1

    defc    DISPLAY = 0xEC00
    defc    COLOUR_MAP = DISPLAY - 1024 

    EXTERN  ansi_cls
    EXTERN  ansi_SCROLLUP






generic_console_set_attribute:
    ret

generic_console_set_ink:
    call    conio_map_colour
    and     7
    rla
    rla
    rla
    rla
    ld      e,a
    ld      a,(__z9001_attr)
    and     @00001111
    or      e
    ld      (__z9001_attr),a
    ret

	
generic_console_set_paper:
    call    conio_map_colour
    and     7
    ld      e,a
    ld      a,(__z9001_attr)
    and     @11110000
    or      e
    ld      (__z9001_attr),a
    ret


generic_console_cls:
    ld      a,(__z9001_mode)
    and     a
    jp      nz,cls_MODE1
    jp      ansi_cls

generic_console_scrollup:
    ld      a,(__z9001_mode)
    and     a
    jp      nz,scrollup_MODE1
    jp      ansi_SCROLLUP

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    ld      a,(__z9001_mode)
    and     a
    ld      a,d
    jp      nz,printc_MODE1
    call    xypos
    ld      (hl),a
    dec     h
    dec     h
    dec     h
    dec     h
    ld      a,(generic_console_flags)
    rlca
    ld      a,(__z9001_attr)
    jr      nc,not_inverse
    rlca
    rlca
    rlca
    rlca
not_inverse:
    ld      (hl),a
    ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      a,(__z9001_mode)
    and     a
    jp      nz,vpeek_MODE1
    call    xypos
    ld      a,(hl)
    and     a
    ret


xypos:
    ld      hl,DISPLAY - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc           ;hl now points to address in display
    ret

