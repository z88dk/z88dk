; $Id: bit_fx7.asm  $
;
; A "memory write" I/O variant is not necessary,
; this effects library is totally based on the external "noise" fn
;
; Generic platform sound effects module.
;
; Library #4 by Stefano Bodrato
;

  IF    !__CPU_GBZ80__
        SECTION code_clib
        PUBLIC  bit_fx7
        PUBLIC  _bit_fx7
        INCLUDE "games/games.inc"

        EXTERN  noise
        EXTERN  bit_open
        EXTERN  bit_open_di
        EXTERN  bit_close
        EXTERN  bit_close_ei
        EXTERN  bit_click

;Sound routine..enter in with e holding the desired effect!


bit_fx7:
_bit_fx7:
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
        defw    fx2
        defw    fx3
        defw    fx4
        defw    fx5
        defw    fx6
        defw    fx7
        defw    fx8


; short noise
fx1:
        call    bit_open_di
        ld      b, 1
fx1_1:  push    bc
        ld      hl, 600
        ld      de, 2
fx1_2:  push    hl
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


; Crash/Explosion
fx2:
        call    bit_open_di
        ld      hl, 220
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


; Explosion

fx3:
        call    bit_open_di
        ld      hl, 1024
fx3_1:
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
        ld      a, l
        cp      80
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
        ld      bc, 900
        sbc     hl, bc
        call    noise
        pop     de
        pop     hl

        inc     hl
        ld      a, l
        cp      80
        jr      nz, fx4_1
        jp      bit_close_ei


; FX5 effect
fx5:
        call    bit_open_di
        ld      hl, 1124
        ld      de, 1
fx5_1:
        push    hl
        push    de
        ld      bc, 1000
        sbc     hl, bc
        call    noise
        pop     de
        pop     hl

        inc     hl
        ld      a, l
        and     a
        jr      nz, fx5_1
        jp      bit_close_ei



; FX6 effect
fx6:
        call    bit_open_di
        ld      hl, 220
        ld      de, 1
fx6_1:

        push    hl
        push    de
        call    noise
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
        cp      240
        jr      nz, fx6_1
        jp      bit_close_ei



; FX7 effect
fx7:
        call    bit_open_di
        ld      hl, 300
        ld      de, 1
fx7_1:
        push    hl
        push    de
        call    noise
        pop     de
        pop     hl

        push    hl
        push    de
        ld      bc, 200
        sbc     hl, bc
        call    noise
        pop     de
        pop     hl

        inc     hl
        inc     de
        ld      a, l
        and     60
        jr      nz, fx7_1
        jp      bit_close_ei


; FX8 effect
fx8:
        call    bit_open_di
        ld      hl, 320
fx8_1:
        ld      de, 1
        push    hl
        push    de
        ld      a, 88
        xor     l
        ld      l, a
        call    noise
        pop     de
        pop     hl
        dec     hl
        ld      a, h
        or      l
        jr      nz, fx8_1
        jp      bit_close_ei

  ENDIF
