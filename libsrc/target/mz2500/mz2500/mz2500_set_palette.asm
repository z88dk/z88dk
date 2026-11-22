;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_set_palette(uint8_t n, uint8_t r, uint8_t g, uint8_t b) __smallc;
;
;	Set entry n (0-15) of the 4096 colour palette; r, g and b are 0-15.
;

    SECTION code_clib
    PUBLIC  mz2500_set_palette
    PUBLIC  _mz2500_set_palette

mz2500_set_palette:
_mz2500_set_palette:
    pop     hl
    pop     de                          ; b
    ld      a,e
    and     $0f
    ld      e,a
    pop     bc                          ; g
    ld      a,c
    and     $0f
    ld      d,a                         ; d = g
    pop     bc                          ; r
    ld      a,c
    and     $0f
    rlca
    rlca
    rlca
    rlca
    or      e
    ld      e,a                         ; e = r << 4 | b
    pop     bc                          ; n
    push    bc
    push    bc
    push    bc
    push    bc
    push    hl
    ld      a,c
    add     a,a
    ld      b,a
    ld      c,$ae
    out     (c),e
    inc     b
    out     (c),d
    ret
