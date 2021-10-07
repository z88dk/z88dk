; Substitute for 'sub hl, de' instruction
; CPU   Min T Max T
; 8080  86    86
; 8085  82    82
; gbz80 80    80
; r2ka  53    53
; z180  77    77
; z80   80    80
; z80n  80    80

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sub_hl_de

__z80asm__sub_hl_de:
        push    bc
        ld      b, a

        ld      a, l
        sub     a, e
        ld      l, a

        ld      a, h
        sbc     a, d
        ld      h, a

        ld      a, b
        pop     bc
        ret
