

MODULE rc700_loadfont

PUBLIC rc700_loadfont

INCLUDE "target/cpm/def/rc700.h"

;
; Semigraphics is 11 rows
;
; Pad 1 line at top, 2 at bottom
;
; hl = font
;  b = start character
;  c = number of characters
rc700_loadfont:
loadfont_1:
    push    bc

    ld      a, b
    out     (IO_RC700_SEM702_CHAR),a
    xor     a   ;First line
    out     (IO_RC700_SEM702_LINE),a
    out     (IO_RC700_SEM702_DATA),a

     ;Next 8 lines
    ld      c,1
loadfont_2:
    ld      a,c
    out     (IO_RC700_SEM702_LINE),a
    ld      a,(hl)
    ; Hardware mirrored, so flip the byte
    ld      e,a
    ; Mirror for RAM fonts
    rlca
    rlca
    xor     e
    and     0xaa
    xor     e
    ld      e, a
    rlca
    rlca
    rlca
    rrc     e
    xor     e
    and     0x66
    xor     e
    out     (IO_RC700_SEM702_DATA),a
    inc     hl
    inc     c
    ld      a, c
    cp      9
    jr      nz, loadfont_2

    ld      a, c
    out     (IO_RC700_SEM702_LINE),a
    xor     a
    out     (IO_RC700_SEM702_DATA),a  
    inc     c
    ld      a, c
    out     (IO_RC700_SEM702_LINE),a
    xor     a
    out     (IO_RC700_SEM702_DATA),a  

    pop     bc
    inc     b
    dec     c
    jr      nz, loadfont_1
    ret
