        SECTION code_l_sdcc

        PUBLIC  __muluschar

        GLOBAL  l_mul8_signexte

__muluschar:
        ld      hl,sp+2
        ld      b, 0

        ld      e,(hl)
        inc     hl
        ld      c,(hl)
        jp      l_mul8_signexte
