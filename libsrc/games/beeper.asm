; $Id: beeper.asm $
;
; Generic 1 bit sound functions
;

        SECTION code_clib
        PUBLIC  beeper
        PUBLIC  _beeper
        INCLUDE "games/games.inc"

    ;EXTERN      bit_open_di
    ;EXTERN      bit_close_ei
        EXTERN  __snd_tick

;
; Ported by Dominic Morris
; Adapted by Stefano Bodrato
;
; Entry as for Spectrum beeper routine!!
;
; Direct transfer, of code..no point commenting really
;


beeper:
_beeper:
  IF    __CPU_GBZ80__
        ret
  ELSE

    IF  __CPU_GBZ80__||__CPU_INTEL__
        ld      a, l
        and     a
        rra
        and     a
        rra
        ld      c, a
        ld      a, l
        ld      l, c

    ELSE

        push    ix
      IF    SOUND_ONEBIT_port>=256
        exx
        ld      bc, SOUND_ONEBIT_port
        exx
      ENDIF
        ld      a, l
        srl     l
        srl     l

    ENDIF

        cpl
        and     3
        ld      c, a
        ld      b, 0
    IF  __CPU_GBZ80__||__CPU_INTEL__
        push    hl
        ld      hl, beixp3
        add     hl, bc
    ELSE
        ld      ix, beixp3
        add     ix, bc
    ENDIF
    ;call bit_open_di
        ld      a, (__snd_tick)

beixp3:
        nop
        nop
        nop
        inc     b
        inc     c
    IF  __CPU_GBZ80__||__CPU_INTEL__
        ex      (sp), hl
    ENDIF
behllp: dec     c
        jr      nz, behllp
        ld      c, $3F
        dec     b
        jp      nz, behllp
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        ld      b, h
        ld      c, a
    IF  __CPU_GBZ80__||__CPU_INTEL__
        and     SOUND_ONEBIT_mask
        ld      a, c
    ELSE
        bit     SOUND_ONEBIT_bit, a     ;if o/p go again!
    ENDIF
        jr      nz, be_again
        ld      a, d
        or      e
        jr      z, be_end
        ld      a, c
        ld      c, l
        dec     de
    IF  __CPU_GBZ80__||__CPU_INTEL__
        ex      (sp), hl
        jp      (hl)
    ELSE
        jp      (ix)
    ENDIF
be_again:
        ld      c, l
        inc     c
    IF  __CPU_GBZ80__||__CPU_INTEL__
        ex      (sp), hl
        jp      (hl)
    ELSE
        jp      (ix)
    ENDIF
be_end:
    IF  __CPU_GBZ80__||__CPU_INTEL__
        pop     hl
    ELSE
        pop     ix
    ENDIF
    ;call   bit_close_ei
        ret

  ENDIF
