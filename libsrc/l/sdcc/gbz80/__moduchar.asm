
        SECTION code_l_sdcc

        PUBLIC  __moduchar

        GLOBAL  l_divu8

__moduchar:
        ld      hl,sp+3

        ld      e,(hl)
        dec     hl
        ld      l,(hl)

        ld      c,l
        call    l_divu8

        ;; Already in DE

        ret
