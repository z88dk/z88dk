

        SECTION code_l_sdcc

        PUBLIC  __modschar

        GLOBAL  l_div8

__modschar:
        ld      hl,sp+3

        ld      e,(hl)
        dec     hl
        ld      l,(hl)

        ld      c,l

        call    l_div8

        ;; Already in DE

        ret
