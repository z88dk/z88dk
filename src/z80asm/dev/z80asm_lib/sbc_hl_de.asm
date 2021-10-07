; Substitute for the z80 sbc hl,de instruction
; CPU   Min T Max T
; 8080  86    86
; 8085  82    82
; gbz80 80    80
; r2ka   4     4
; z180  10    10
; z80   15    15
; z80n  15    15

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sbc_hl_de

__z80asm__sbc_hl_de:
        push    bc
        ld      b, a

        ld      a, l
        sbc     a, e
        ld      l, a

        ld      a, h
        sbc     a, d
        ld      h, a

        ld      a, b
        pop     bc
        ret
