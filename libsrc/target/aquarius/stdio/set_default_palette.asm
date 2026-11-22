
SECTION code_clib

INCLUDE "target/aquarius/def/aqplus.def"

PUBLIC set_default_palette


; Set the default palette for bitmap mode
; We use the same as for text mode
set_default_palette:
    ld      hl,palette
    xor     a
next:
    push    af
    rlca
    or      @00100000       ;Palette 1, set GB
    ld      b,a
    out     (PORT_VPALSEL),a
    ld      a,(hl)
    inc     hl
    out     (PORT_VPALDATA),a
    ld      a,b
    or      @00000001       ;Set R
    out     (PORT_VPALSEL),a
    ld      a,(hl)
    inc     hl
    out     (PORT_VPALDATA),a
    pop     af
    inc     a
    cp      16
    jr      nz,next
    ret


SECTION rodata_clib

palette:
    defw    0x111, 0xF11, 0x1F1, 0xFF1, 0x22E, 0xF1F, 0x3CC, 0xFFF
    defw    0xCCC, 0x3BB, 0xC2C, 0x419, 0xFF7, 0x2D4, 0xB22, 0x333