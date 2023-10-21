; $Id: bit_fx5.asm  $
;
; Generic platform sound effects module.
;
; Library #5 by Stefano Bodrato
;

  IF    !__CPU_GBZ80__
        SECTION code_clib
        PUBLIC  bit_fx5
        PUBLIC  _bit_fx5
        INCLUDE "games/games.inc"

        EXTERN  beeper
        EXTERN  noise
        EXTERN  bit_open
        EXTERN  bit_open_di
        EXTERN  bit_close
        EXTERN  bit_close_ei
        EXTERN  bit_click

;Sound routine..enter in with e holding the desired effect!


bit_fx5:
_bit_fx5:
        ld      a, l
        cp      8
        ret     nc
        add     a, a
        ld      e, a
        ld      d, 0
        ld      hl, table
        add     hl, de
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        jp      (hl)

table:  defw    fx1                     ; effect #0
        defw    fx1b
        defw    fx2
        defw    fx2b
        defw    fx3
        defw    fx4
        defw    fx5
        defw    fx6


; Slippery floor, a bit like Mario on "Donkey Kong"
fx1:
        call    bit_open_di
        ld      b, 1
fx1_1:  push    bc
        ld      hl, 600
        ld      de, 2
fx1_2:  push    hl
        push    de
        call    beeper
        pop     de
        pop     hl
        push    hl
        push    de
        ld      bc, 400
        sbc     hl, bc
        ld      l, c
        ld      h, b
        call    noise
        pop     de
        pop     hl
        ld      bc, 40
        and     a
        sbc     hl, bc
        jr      nc, fx1_2
        pop     bc
        djnz    fx1_1
        jp      bit_close_ei


; Hitting a wall.. or someone
fx1b:
        call    bit_open_di
        ld      b, 1
fx1b_1: push    bc
        ld      hl, 600
        ld      de, 2
fx1b_2: push    hl
        push    de
        call    noise
        pop     de
        pop     hl
        push    hl
        push    de
        ld      bc, 400
        sbc     hl, bc
        ld      l, c
        ld      h, b
        call    beeper
        pop     de
        pop     hl
        ld      bc, 40
        and     a
        sbc     hl, bc
        jr      nc, fx1b_2
        pop     bc
        djnz    fx1b_1
        jp      bit_close_ei


; Shooting with a.. gun
fx2:
        call    bit_open_di
        ld      hl, 70
fx2_1:
        ld      de, 1
        push    hl
        push    de
        ld      a, 55
        xor     l
        ld      l, a
        call    noise
        pop     de
        pop     hl
        dec     hl
        ld      a, h
        or      l
        jr      nz, fx2_1
        jp      bit_close_ei


; Kiss
fx2b:
        call    bit_open_di
        ld      hl, 70
fx2b_1:
        ld      de, 1
        push    hl
        push    de
        ld      a, 55
        xor     l
        ld      l, a
        call    beeper
        pop     de
        pop     hl
        push    hl
        push    de
        ld      a, 87
        xor     l
        ld      l, a
        call    beeper
        pop     de
        pop     hl
        dec     hl
        ld      a, h
        or      l
        jr      nz, fx2b_1
        jp      bit_close_ei


; FX3 effect
fx3:
        call    bit_open_di
        ld      hl, 30
        ld      de, 1
fx3_1:
        push    hl
        push    de
        call    beeper
        ld      hl, 600
        ld      de, 1
        call    beeper
        pop     de
        pop     hl
        push    hl
        push    de
        call    noise
        pop     de
        pop     hl
        dec     hl
        inc     de
        ld      a, h
        or      l
        jr      nz, fx3_1
        jp      bit_close_ei


; FX4 effect
fx4:
        call    bit_open_di
        ld      hl, 1124
        ld      de, 1
fx4_1:

        push    hl
        push    de
        call    noise
        pop     de
        pop     hl

        push    hl
        push    de
        ld      bc, 900
        sbc     hl, bc
        call    beeper
        pop     de
        pop     hl

        inc     hl
        ld      a, l
        and     a
        jr      nz, fx4_1
        jp      bit_close_ei


; Crashing and falling
; FX5 effect
fx5:
        call    bit_open_di
        ld      hl, 200
        ld      de, 1
fx5_1:

        push    hl
        push    de
        call    beeper
        pop     de
        pop     hl

        push    hl
        push    de
        ld      bc, 180
        sbc     hl, bc
        call    noise
        pop     de
        pop     hl

        inc     hl
        inc     de
        ld      a, l
        cp      250
        jr      nz, fx5_1
        jp      bit_close_ei



; FX6 effect
fx6:
        call    bit_open_di
        ld      hl, 300
        ld      de, 1
fx6_1:
        push    hl
        push    de
        call    noise
        pop     de
        pop     hl

        push    hl
        push    de
        ld      bc, 200
        sbc     hl, bc
        call    beeper
        pop     de
        pop     hl

        inc     hl
        inc     de
        ld      a, l
        and     50
        jr      nz, fx6_1
        jp      bit_close_ei

  ENDIF
