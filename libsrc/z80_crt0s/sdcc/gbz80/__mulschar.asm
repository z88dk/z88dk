
        SECTION code_l_sdcc

        PUBLIC  __mulschar

        GLOBAL  l_mul8_signexte

__mulschar:
        ld      hl,sp+2

        ld      e,(hl)
        inc     hl
        ld      l,(hl)

        ;; Need to sign extend before going in.
        ld      c,l

        ld      a,l
        rla
        sbc     a,a
        ld      b,a
        jp      l_mul8_signexte
