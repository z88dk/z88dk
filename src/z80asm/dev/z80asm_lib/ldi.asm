; Substitute for the z80 ldi instruction
; Doesn't emulate the flags correctly

        SECTION code_l_sccz80
        PUBLIC  __z80asm__ldi

__z80asm__ldi:
        push    af                      ;Save incoming flags
  IF    __CPU_GBZ80__
        ld      a, (hl+)
  ELSE
        ld      a, (hl)
        inc     hl
  ENDIF
        ld      (de), a
        inc     de
        dec     bc
  IF    !__CPU_GBZ80__
                              ; There's no point setting PV flag on a gbz80 since flag doesn't exist
        ex      (sp), hl                ;incoming af in hl, outgoing hl on stack
        push    bc                      ;Save bc, we need a temporary
        ld      a, b
        or      c
        ld      c, 4
        jr      nz, set_pv
        ld      c, 0
set_pv:
        ld      a, l
        and     @11101001               ;Knock out H + N flags as well
        or      c                       ;Add in PV flag required
        ld      l, a
        pop     bc
        ex      (sp), hl                ;Get hl back
  ENDIF
        pop     af                      ;And restore our modified af
        ret
