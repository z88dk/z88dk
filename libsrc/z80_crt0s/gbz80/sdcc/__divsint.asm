
        SECTION code_l_sdcc

        PUBLIC  __divsint

        GLOBAL  l_div16

__divsint:
        ld      hl,sp+5

        ld      d,(hl)
        dec     hl
        ld      e,(hl)
        dec     hl
        ld      a,(hl)
        dec     hl
        ld      l,(hl)
        ld      h,a

        ld      b,h
        ld      c,l

        call    l_div16

        ld      e,c
        ld      d,b

        ret

