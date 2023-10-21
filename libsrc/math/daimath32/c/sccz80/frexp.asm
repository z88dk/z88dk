
        SECTION code_fp

        PUBLIC  frexp


; float frexpf (float x, int8_t *pw2);
frexp:
  IF    __CPU_INTEL__||__CPU_GBZ80__
        ld      hl, sp+2
        ld      c, (hl)                 ;pw2
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      e, (hl)                 ;float
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        ex      de, hl
  ELSE
        pop     af                      ;Return
        pop     bc                      ;pw2
        pop     hl                      ;float
        pop     de
        push    de
        push    hl
        push    bc
        push    af
  ENDIF

        ld      a, d
        and     a
        ld      d, 0
        jr      z, zero
        and     $7f
        ld      d, $00                  ;And set to non-scaled
zero:
        ld      (bc), a
        inc     bc
        rlca
        rlca
        sbc     a
        ld      (bc), a
        ret
