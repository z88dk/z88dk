

        SECTION code_fp_dai32
        PUBLIC  ldexp

; float ldexpf (float x, int16_t pw2)
ldexp:
        ld      hl, 2
        add     hl, sp
        ld      c, (hl)                 ;pw2
        ld      hl, 7
        add     hl, sp                  ;exponent
        ld      a, (hl)
        and     127
        jr      z, skip
        add     c
        ld      c, a
        ld      a, (hl)
        and     $80
        or      c
skip:
        ld      d, a
        dec     hl
        ld      e, (hl)
        dec     hl
        ld      a, (hl)
        dec     hl
        ld      l, (hl)
        ld      h, a
        ret
