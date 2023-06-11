

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    EXTERN  KRT_PORT
    EXTERN  KRT_DISABLE
    EXTERN  cls_MODE1
    EXTERN  printc_MODE1
    EXTERN  vpeek_MODE1
    EXTERN  scrollup_MODE1
    EXTERN  __z1013_mode

    defc    DISPLAY = 0xEC00


generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
    ret

generic_console_cls:
    ld      a,(__z1013_mode)
    and     a
    jp      nz,cls_MODE1
    ld      a,KRT_DISABLE
    out     (KRT_PORT),a
    ld      hl, DISPLAY
    ld      de, DISPLAY +1
    ld      bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
    ld      (hl),32
    ldir
    ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    ld      a,(__z1013_mode)
    and     a
    ld      a,d
    jp      nz,printc_MODE1
    call    xypos
    ld      (hl),a
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      a,(__z1013_mode)
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
    add     hl,bc			;hl now points to address in display
    ret


generic_console_scrollup:
    ld      a,(__z1013_mode)
    and     a
    jp      nz,scrollup_MODE1
    push    de
    push    bc
    ld      hl, DISPLAY + CONSOLE_COLUMNS
    ld      de, DISPLAY
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
