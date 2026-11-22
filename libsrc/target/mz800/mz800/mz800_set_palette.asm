; void mz800_set_palette(uint8_t entry, uint8_t colour)
; Palette entry 0-3 (the pixel value in the 4 colour modes) = colour 0-15 (IGRB: 1 blue, 2 red, 4 green, 8 bright)

    SECTION code_clib
    PUBLIC  mz800_set_palette
    PUBLIC  _mz800_set_palette
    PUBLIC  mz800_set_palette_callee
    PUBLIC  _mz800_set_palette_callee
    PUBLIC  asm_mz800_set_palette

mz800_set_palette:
_mz800_set_palette:
    pop     af
    pop     de              ; e = colour
    pop     hl              ; l = entry
    push    hl
    push    de
    push    af
    jr      asm_mz800_set_palette

mz800_set_palette_callee:
_mz800_set_palette_callee:
    pop     af
    pop     de              ; e = colour
    pop     hl              ; l = entry
    push    af

; enter with l = entry, e = colour
asm_mz800_set_palette:
    ld      a,l
    and     3
    rlca
    rlca
    rlca
    rlca
    ld      l,a
    ld      a,e
    and     $0f
    or      l
    out     ($f0),a
    ret
