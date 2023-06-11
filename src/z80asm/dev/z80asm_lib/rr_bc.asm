; Emulate 'rr bc' instruction, only carry is affected
; CPU   Min T Max T
; 8080  90    90
; 8085  88    88
; gbz80 16    16
; r2ka   8     8
; z180  14    14
; z80   16    16
; z80n  16    16

        SECTION code_l_sccz80
        PUBLIC  __z80asm__rr_bc

__z80asm__rr_bc:

  IF    __CPU_INTEL__
        push    af

        ld      a, b
        rra
        ld      b, a

        ld      a, c
        rra
        ld      c, a

        jr      nc, carry0
        pop     af
        scf
        ret
carry0:
        pop     af
        and     a
        ret
  ELSE
        rr      b
        rr      c
        ret
  ENDIF

