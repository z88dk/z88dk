; Substitute for z80 cpd instruction
; aralbrec 06.2007

        SECTION code_l_sccz80
        PUBLIC  __z80asm__cpd

  IF    __CPU_GBZ80__
        EXTERN  __z80asm__ex_sp_hl
  ENDIF

__z80asm__cpd:

        jr      c, cpdwcarry

        cp      (hl)
        dec     hl
        dec     bc

        push    af
  IF    __CPU_GBZ80__
        call    __z80asm__ex_sp_hl
  ELSE
        ex      (sp), hl
  ENDIF
  IF    __CPU_INTEL__
        ld      a, l
        and     @11111110
        ld      l, a
  ELSE
        res     0, l                    ; clear carry
  ENDIF

rejoin:

  IF    __CPU_INTEL__
        ld      a, l
        or      @00000010
        ld      l, a
  ELSE
        set     2, l                    ; set P/V -> BC != 0
  ENDIF

        ld      a, b
        or      c
        jr      nz, exitcpd
  IF    __CPU_INTEL__
        ld      a, l
        and     @11111101
        ld      l, a
  ELSE
        res     2, l                    ; clear P/V -> BC == 0
  ENDIF

exitcpd:

  IF    __CPU_GBZ80__
        call    __z80asm__ex_sp_hl
  ELSE
        ex      (sp), hl
  ENDIF
        pop     af
        ret

cpdwcarry:

        cp      (hl)
        dec     hl
        dec     bc

        push    af
  IF    __CPU_GBZ80__
        call    __z80asm__ex_sp_hl
  ELSE
        ex      (sp), hl
  ENDIF
  IF    __CPU_INTEL__
        ld      a, l
        or      @00000001
        ld      l, a
  ELSE
        set     0, l                    ; set carry
  ENDIF
        jr      rejoin
