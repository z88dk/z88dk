; Substitute for z80 cpi instruction
; aralbrec 06.2007

        SECTION code_l_sccz80
        PUBLIC  __z80asm__cpi

  IF    __CPU_GBZ80__
        EXTERN  __z80asm__ex_sp_hl
  ENDIF

__z80asm__cpi:

        jr      c, cpiwcarry

        cp      (hl)
        inc     hl
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
        or      @00000100
        ld      l, a
  ELSE
        set     2, l                    ; set P/V -> BC != 0
  ENDIF

        ld      a, b
        or      c
        jr      nz, exitcpi
  IF    __CPU_INTEL__
        ld      a, l
        and     @11111011
        ld      l, a
  ELSE
        res     2, l                    ; clear P/V -> BC == 0
  ENDIF

exitcpi:

  IF    __CPU_GBZ80__
        call    __z80asm__ex_sp_hl
  ELSE
        ex      (sp), hl
  ENDIF
        pop     af
        ret

cpiwcarry:

        cp      (hl)
        inc     hl
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
