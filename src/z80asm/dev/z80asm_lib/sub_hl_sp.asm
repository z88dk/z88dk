; Substitute for 'sbc hl, sp' instruction
; CPU   Min T Max T
; 8080  156   156
; 8085  154   154
; gbz80 232   232
; r2ka  111   111
; z180  146   146
; z80   151   151
; z80n  151   151

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sub_hl_sp

__z80asm__sub_hl_sp:
        push    bc
        ld      b, a
        push    de
        ex      de, hl                  ; subtrahed to de

  IF    __CPU_GBZ80__
        ld      hl, sp+6                ; minuend to hl, compensate for return address, DE and BC in stack
  ELSE
        push    af
        ld      hl, 8                   ; minuend to hl, compensate for return address, DE, BC and AF in stack
        add     hl, sp
        pop     af
  ENDIF
        ld      a, e
        sub     a, l
        ld      e, a

        ld      a, d
        sbc     a, h
        ld      d, a

        ex      de, hl
        pop     de
        ld      a, b
        pop     bc
        ret
