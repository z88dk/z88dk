; $Id: bit_fx.asm $
;
; Generic platform sound effects module.
;
; Original code by Dominic Morris
; Adapted by Stefano Bodrato
;
;>Z88 sounds..hopefully!!
;>Works..kinda nice to hear the z88 sing..now for music!
;>djm June 1998
;>
;>This is quite a crude module, $4B0 isn't restored by most routines
;>due to the fact that it is usually in the 00xxxxxx state when we
;>get there

  IF    !__CPU_GBZ80__
        SECTION smc_clib
        PUBLIC  bit_fx
        PUBLIC  _bit_fx
        INCLUDE "games/games.inc"

        EXTERN  beeper
        EXTERN  bit_open
        EXTERN  bit_open_di
        EXTERN  bit_close
        EXTERN  bit_close_ei


;Sound routine..enter in with e holding the desired effect!


bit_fx:
_bit_fx:

    IF  SOUND_ONEBIT_port>=256
        exx
        ld      bc, SOUND_ONEBIT_port
        exx
    ENDIF
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

table:
        defw    fx2                     ; effect #0
        defw    fx5
        defw    fx6
        defw    zap0
        defw    zap1
        defw    clackson
        defw    zap3
        defw    warpcall                ; effect #7


;Strange squeak hl=300,de=2
;Game up hl=300,de=10 inc de
;-like a PACMAN sound
fx6:
        call    bit_open_di
        ld      b, 1
fx6_1:  push    bc
        ld      hl, 300
        ld      de, 10
fx6_2:  push    hl
        push    de
        call    beeper
        pop     de
        pop     hl
;      inc  de           ;if added in makes different sound..
        ld      bc, 10
        and     a
        sbc     hl, bc
        jr      nc, fx6_2
        pop     bc
        djnz    fx6_1
        jp      bit_close_ei


;Use during key defines?

fx2:
        call    bit_open_di
        ld      e, 150
fx2_1:
        ONEBITOUT
        xor     SOUND_ONEBIT_mask
        ld      b, e
fx2_2:
        djnz    fx2_2
        inc     e
        jr      nz, fx2_1
        jp      bit_close_ei


;Laser repeat sound
fx5:
        call    bit_open_di
        ld      b, 1
fx5_1:
        push    bc
        ld      hl, 1200
        ld      de, 6
fx5_2:
        push    hl
        push    de
        call    beeper
        pop     de
        pop     hl
        ld      bc, 100
        and     a
        sbc     hl, bc
        jr      nc, fx5_2
        pop     bc
        djnz    fx5_1
        jp      bit_close_ei


;Eating sound
zap0:
        call    bit_open_di
        ld      h, 4
zap0_1:
        ld      b, (hl)
        dec     hl
zap0_2:
    IF  __CPU_INTEL__
        dec     b
        jp      nz, zap0_2
    ELSE
        djnz    zap0_2
    ENDIF

        ONEBITOUT

        xor     SOUND_ONEBIT_mask

        ld      e, a
        ld      a, h
        or      l
        jr      z, zap0_3
        ld      a, e
        jr      zap0_1
zap0_3:
        jp      bit_close_ei


;Clackson sound

clackson:
        call    bit_open_di
clackson_LENGHT:
        ld      b, 90
clackson_loop:
        dec     h
        jr      nz, clackson_jump
        xor     SOUND_ONEBIT_mask

        ONEBITOUT

clackson_FR_1:
        ld      h, 230
clackson_jump:
        dec     l
        jr      nz, clackson_loop
        xor     SOUND_ONEBIT_mask

        ONEBITOUT

clackson_FR_2:
        ld      l, 255
        djnz    clackson_loop
        jp      bit_close_ei


;Beep thing

zap3:
        call    bit_open_di
zap3_1:
        push    bc
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        push    af
        xor     a
        sub     b
        ld      b, a
        pop     af
zap3_2:
        nop
        djnz    zap3_2
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        pop     bc
        push    bc
zap3_3:
        nop
        djnz    zap3_3
        pop     bc
        djnz    zap3_1
        jp      bit_close_ei


;Sound for warp

warpcall:
        call    bit_open_di
        ld      hl, 1600
        ld      (warps+1), hl
        ld      hl, -800
        ld      (warps1+1), hl
        ld      hl, -100
        ld      (warps2+1), hl
        ld      b, 20
warpcall1:
        push    bc
        call    warps
        pop     bc
        djnz    warpcall1
        jp      bit_close_ei

warps:
        ld      hl, 1600
        ld      de, 6
        call    beeper
warps1:
        ld      hl, -800
warps2:
        ld      de, -100
        and     a
        sbc     hl, de
        ld      (warps1+1), hl
        jr      nz, warps3
        ld      de, 100
        ld      (warps2+1), de
warps3:
        ex      de, hl
        ld      hl, 1600
        add     hl, de
        ld      (warps+1), hl
        ret


;Our old squelch...

zap1:
        call    bit_open
        ld      b, 0
zap1_1:
        push    bc
        xor     SOUND_ONEBIT_mask       ;oscillate between high and low bits...

        ONEBITOUT

zap1_2:
        nop
        nop
        djnz    zap1_2
        pop     bc
        djnz    zap1_1
        jp      bit_close
  ENDIF
