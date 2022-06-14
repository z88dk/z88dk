; Emulate 'rr de' instruction, only carry is affected
; CPU   Min T Max T
; 8080  90    90
; 8085  88    88
; gbz80 16    16
; r2ka   2     2
; z180  14    14
; z80   16    16
; z80n  16    16

        SECTION code_l_sccz80
        PUBLIC  __z80asm__rr_de

__z80asm__rr_de:

  IF    __CPU_INTEL__
        push    af

        ld      a, d
        rra
        ld      d, a

        ld      a, e
        rra
        ld      e, a

        jr      nc, carry0
        pop     af
        scf
        ret
carry0:
        pop     af
        and     a
        ret
  ELSE
        rr      d
        rr      e
        ret
  ENDIF

