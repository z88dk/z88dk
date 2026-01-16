
        SECTION code_l_sdcc

        PUBLIC  __divuschar

        GLOBAL  l_div8_signexte

__divuschar:
        ld      hl,sp+3

        ld      e,(hl)
        dec     hl
        ld      c,(hl)

        ld      a,c             ; Sign extend
        rlca
        sbc     a
        ld      b,a

        call    l_div8_signexte

        ld      e,c
        ld      d,b

        ret
