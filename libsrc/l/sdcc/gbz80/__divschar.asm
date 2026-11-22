

        SECTION code_l_sdcc

        PUBLIC  __divschar

        GLOBAL  l_div8

__divschar:
        ld      hl,sp+3

        ld      e,(hl)
        dec     hl
        ld      l,(hl)

        ld      c,l

        call    l_div8

        ld      e,c
        ld      d,b

        ret
