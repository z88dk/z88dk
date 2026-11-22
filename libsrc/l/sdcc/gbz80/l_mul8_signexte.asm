
        SECTION code_l_sdcc

        PUBLIC  l_mul8_signexte
 
        GLOBAL  l_mul16



l_mul8_signexte:
        ld      a,e
        rla
        sbc     a,a
        ld      d,a

        jp      l_mul16
