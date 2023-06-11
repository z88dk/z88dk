; Emulate 'sra hl' instruction, only carry is affected
; CPU   Min T Max T
; 8080  99    99
; 8085   7     7
; gbz80 16    16
; r2ka   8     8
; z180  14    14
; z80   16    16
; z80n  16    16

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sra_hl

__z80asm__sra_hl:

  IF    __CPU_INTEL__
        push    af

        ld      a, h
        rla                             ; save bit 7 in carry
        ld      a, h
        rra                             ; rotate right, maitain bit 7
        ld      h, a

        ld      a, l
        rra
        ld      l, a

        jr      nc, carry0

        pop     af
        scf
        ret

carry0:
        pop     af
        and     a
        ret
  ELSE
        sra     h
        rr      l
        ret
  ENDIF

