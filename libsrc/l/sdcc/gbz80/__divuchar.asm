
        SECTION code_l_sdcc

        PUBLIC  __divuchar

        GLOBAL  l_divu8

        ;; Unsigned
__divuchar:
        ld      hl,sp+3

        ld      e,(hl)
        dec     hl
        ld      l,(hl)

        ld      c,l
        call    l_divu8

        ld      e,c
        ld      d,b

        ret
