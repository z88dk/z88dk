; Emulate 'sra de' instruction, only carry is affected
; CPU   Min T Max T
; 8080  99    99
; 8085  96    96
; gbz80 16    16
; r2ka   8     8
; z180  14    14
; z80   16    16
; z80n  16    16

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sra_de

__z80asm__sra_de:

  IF    __CPU_INTEL__
        push    af

        ld      a, d
        rla                             ; save bit 7 in carry
        ld      a, d
        rra                             ; rotate right, maitain bit 7
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
        sra     d
        rr      e
        ret
  ENDIF

