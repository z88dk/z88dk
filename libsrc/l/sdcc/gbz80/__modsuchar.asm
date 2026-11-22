
        SECTION code_l_sdcc

        PUBLIC  __modsuchar

        GLOBAL  l_div8_signexte


__modsuchar:
        ld      hl,sp+3

        ld      e,(hl)
        dec     hl
        ld      c,(hl)
        ld      b,0

        jp    l_div8_signexte
