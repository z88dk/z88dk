
        SECTION code_l_sdcc

        PUBLIC  __divuschar

        GLOBAL  l_div16

__divuschar:
        ld      hl,sp+3
        ld      d,0

        ld      e,(hl)
        dec     hl
        ld      c,(hl)

        ld      a,c             ; Sign extend
        rlca
        sbc     a
        ld      b,a

        call    l_div16

        ld      e,c
        ld      d,b

        ret
