
        SECTION code_l_sdcc

        PUBLIC  __modsint

        GLOBAL  l_div16

__modsint:
        ld      hl,sp+5

        ld      d,(hl)
        dec     hl
        ld      e,(hl)
        dec     hl
        ld      b,(hl)
        dec     hl
        ld      c,(hl)

        call    l_div16

        ;; Already in DE

        ret

