
        SECTION code_l_sdcc

        PUBLIC  __mulsuchar

        GLOBAL  l_mul8_signexte

__mulsuchar:
        ld      hl,sp+3
        ld      b, 0

        ld      e,(hl)
        dec     hl
        ld      c,(hl)
        jp      l_mul8_signexte
