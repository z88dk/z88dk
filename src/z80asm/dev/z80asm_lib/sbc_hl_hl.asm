; Substitute for the z80 sbc hl,hl instruction
; CPU   Min T Max T
; 8080  38    47
; 8085  40    50
; gbz80 32    48
; r2ka   4     4
; z180  10    10
; z80   15    15
; z80n  15    15

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sbc_hl_hl

__z80asm__sbc_hl_hl:
        ld      hl, 0
        ret     nc
        dec     hl
        ret
