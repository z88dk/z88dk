; Substitute for the z80 sbc hl,bc instruction
; CPU   Min T Max T
; 8080  86    86
; 8085  82    82
; gbz80 80    80
; r2ka   4     4
; z180  10    10
; z80   15    15
; z80n  15    15

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sbc_hl_bc

__z80asm__sbc_hl_bc:
        push    de
        ld      d, a

        ld      a, l
        sbc     a, c
        ld      l, a

        ld      a, h
        sbc     a, b
        ld      h, a

        ld      a, d
        pop     de
        ret
