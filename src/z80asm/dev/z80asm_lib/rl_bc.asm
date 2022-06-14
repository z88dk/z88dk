; Emulate 'rl bc' instruction, only carry is affected
; CPU   Min T Max T
; 8080  90    90
; 8085  88    88
; gbz80 16    16
; r2ka   8     8
; z180  14    14
; z80   16    16
; z80n  16    16

        SECTION code_l_sccz80
        PUBLIC  __z80asm__rl_bc

__z80asm__rl_bc:

  IF    __CPU_INTEL__
        push    af

        ld      a, c
        rla
        ld      c, a

        ld      a, b
        rla
        ld      b, a

        jr      nc, carry0
        pop     af
        scf
        ret
carry0:
        pop     af
        and     a
        ret
  ELSE
        rl      c
        rl      b
        ret
  ENDIF

