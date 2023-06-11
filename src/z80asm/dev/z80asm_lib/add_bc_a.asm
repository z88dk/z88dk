; Substitute for the z80 add bc,a instruction
; no flags are affected
; CPU   Min T Max T
; 8080  74    74
; 8085  73    73
; gbz80 72    72
; r2ka  52    52
; z180  69    69
; z80   71    71
; z80n   8     8

        SECTION code_l_sccz80
        PUBLIC  __z80asm__add_bc_a

__z80asm__add_bc_a:
        push    af

        add     a, c
        ld      c, a

        ld      a, b
        adc     a, 0
        ld      b, a

        pop     af
        ret
