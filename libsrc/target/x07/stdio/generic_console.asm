
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
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  clg
    EXTERN  __x07_buffer
    EXTERN  __x07_natural_chars
    EXTERN  __ansichar_4x4

    defc generic_console_cls = clg

    INCLUDE "target/x07/def/x07.h"

generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
    ret


generic_console_scrollup:
    push    de
    push    bc
    // TODO: Issue subcpu command
    ld      a,(__x07_natural_chars)
    and     a
    jr      z,scroll_return


    // Clear our memory buffer
    ld      hl, X07_MIRROR+CONSOLE_COLUMNS
    ld      de, X07_MIRROR
    ld      bc, CONSOLE_COLUMNS * (CONSOLE_ROWS - 1)
    ldir
    ex      de, hl
    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3

scroll_return:
    pop     bc
    pop     de
    ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    ld      a,(__x07_natural_chars)
    and     a
    ld      a,d
    jp      z,__ansichar_4x4
    push    bc
    call    generic_console_xypos
    ld      (hl), a
    pop     bc
    push    af
    // Now we need to print it
    ld      hl,__x07_buffer
    ld      (hl),c
    inc     hl
    ld      (hl),b
    inc     hl
    ld      (hl),a
    dec     hl
    dec     hl
    ld      a, SUB_LOCATE
    ld      bc,0x0300           ;3 input, 0 output
    call    SUB_EXECUTE
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      a,(__x07_natural_chars)
    and     a
    scf
    ret     z
    call    generic_console_xypos
    ld      a, (hl)
    and     a
    ret

generic_console_xypos:
    ld      hl, X07_MIRROR-CONSOLE_COLUMNS
    ld      de, CONSOLE_COLUMNS
    inc     b
generic_console_xypos_1:
    add     hl, de
    djnz    generic_console_xypos_1
    add     hl, bc                      ;hl now points to address in display
    ret

