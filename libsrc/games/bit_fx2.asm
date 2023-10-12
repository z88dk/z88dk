; $Id: bit_fx2.asm $
;
; Generic platform sound effects module.
; Alternate sound library by Stefano Bodrato
;

  IF    !__CPU_GBZ80__
        SECTION smc_clib
        PUBLIC  bit_fx2
        PUBLIC  _bit_fx2
        INCLUDE "games/games.inc"

        EXTERN  bit_open
        EXTERN  bit_open_di
        EXTERN  bit_close
        EXTERN  bit_close_ei


bit_fx2:
_bit_fx2:

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
        defw    DeepSpace               ; effect #0
        defw    SSpace2
        defw    TSpace
        defw    Clackson2
        defw    TSpace2
        defw    TSpace3                 ; effect #5
        defw    Squoink
        defw    explosion

;Space sound

DeepSpace:
        call    bit_open_di
DS_LENGHT:
        ld      b, 100
ds_loop:
        dec     h
        jr      nz, ds_jump
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        push    bc
        ld      b, 250
loosetime1:
        djnz    loosetime1
        pop     bc
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


ds_FR_1:
          ;ld      h,230
        ld      h, 254
ds_jump:
        dec     l
        jr      nz, ds_loop
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        push    bc
        ld      b, 200
loosetime2:
        djnz    loosetime2
        pop     bc
        xor     SOUND_ONEBIT_mask
        ONEBITOUT


ds_FR_2:
        ld      l, 255
        djnz    ds_loop
        call    bit_close_ei
        ret


;Dual note with fuzzy addedd

SSpace2:
        call    bit_open_di
SS_LENGHT:
        ld      b, 100
ss_loop:
        dec     h
        jr      nz, ss_jump
        push    hl
        push    af
        ld      a, SOUND_ONEBIT_mask
        ld      h, 0
        and     (hl)
        ld      l, a
        pop     af
        xor     l

        ONEBITOUT

        pop     hl
        xor     SOUND_ONEBIT_mask
        ONEBITOUT


ss_FR_1:
        ld      h, 230
ss_jump:
        dec     l
        jr      nz, ss_loop
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


ss_FR_2:
        ld      l, 255
        djnz    ss_loop
        call    bit_close_ei
        ret


;Dual note with LOT of fuzzy addedd

TSpace:
        call    bit_open_di
TS_LENGHT:
        ld      b, 100
ts_loop:
        dec     h
        jr      nz, ts_jump
        push    hl
        push    af
        ld      a, SOUND_ONEBIT_mask
        ld      h, 0
        and     (hl)
        ld      l, a
        pop     af
        xor     l

        ONEBITOUT

        pop     hl
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


ts_FR_1:
        ld      h, 130
ts_jump:
        dec     l
        jr      nz, ts_loop
        push    hl
        push    af
        ld      a, SOUND_ONEBIT_mask
        ld      l, h
        ld      h, 0
        and     (hl)
        ld      l, a
        pop     af
        xor     l

        ONEBITOUT


        pop     hl
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


ts_FR_2:
        ld      l, 155
        djnz    ts_loop
        call    bit_close_ei
        ret


Clackson2:
        call    bit_open_di
CS_LENGHT:
        ld      b, 200
cs_loop:
        dec     h
        jr      nz, cs_jump
        xor     SOUND_ONEBIT_mask
        ONEBITOUT


        push    bc
        ld      b, 250
cswait1:
        djnz    cswait1
        pop     bc
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


cs_FR_1:
        ld      h, 230
cs_jump:
        inc     l
        jr      nz, cs_loop
        xor     SOUND_ONEBIT_mask

        ONEBITOUT

        push    bc
        ld      b, 200
cswait2:
        djnz    cswait2
        pop     bc
        xor     SOUND_ONEBIT_mask
        ONEBITOUT


cs_FR_2:
        ld      l, 0
        djnz    cs_loop
        call    bit_close_ei
        ret


TSpace2:
        ld      a, 230
        ld      (t2_FR_1+1), a
        xor     a
        ld      (t2_FR_2+1), a

        call    bit_open_di
T2_LENGHT:
        ld      b, 200
t2_loop:
        dec     h
        jr      nz, t2_jump
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        push    bc
        ld      b, 250
wait1:
        djnz    wait1
        pop     bc
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


t2_FR_1:
        ld      h, 230
t2_jump:
        inc     l
        jr      nz, t2_loop
        push    af
        ld      a, (t2_FR_2+1)
        inc     a
        ld      (t2_FR_2+1), a
        pop     af
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


        push    bc
        ld      b, 200
wait2:
        djnz    wait2
        pop     bc
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


t2_FR_2:
        ld      l, 0
        djnz    t2_loop
        call    bit_close_ei
        ret


TSpace3:
        ld      a, 230
        ld      (u2_FR_1+1), a
        xor     a
        ld      (u2_FR_2+1), a

        call    bit_open_di
U2_LENGHT:
        ld      b, 200
u2_loop:
        dec     h
        jr      nz, u2_jump
        push    af
        ld      a, (u2_FR_1+1)
        inc     a
        ld      (u2_FR_1+1), a
        pop     af
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


u2_FR_1:
        ld      h, 50
u2_jump:
        inc     l
        jr      nz, u2_loop
        push    af
        ld      a, (u2_FR_2+1)
        inc     a
        ld      (u2_FR_2+1), a
        pop     af
        xor     SOUND_ONEBIT_mask

        ONEBITOUT


u2_FR_2:
        ld      l, 0
        djnz    u2_loop
        call    bit_close_ei
        ret


Squoink:
        ld      a, 230
        ld      (qi_FR_1+1), a
        xor     a
        ld      (qi_FR_2+1), a

        call    bit_open_di
qi_LENGHT:
        ld      b, 200
qi_loop:
        dec     h
        jr      nz, qi_jump
        push    af
        ld      a, (qi_FR_1+1)
        dec     a
        ld      (qi_FR_1+1), a
        pop     af
        xor     SOUND_ONEBIT_mask
        ONEBITOUT


qi_FR_1:
        ld      h, 50
qi_jump:
        inc     l
        jr      nz, qi_loop
        push    af
        ld      a, (qi_FR_2+1)
        inc     a
        ld      (qi_FR_2+1), a
        pop     af
        xor     SOUND_ONEBIT_mask

        ONEBITOUT

qi_FR_2:
        ld      l, 0
        djnz    qi_loop
        call    bit_close_ei
        ret


explosion:
        call    bit_open_di
        ld      hl, 1
    IF  __CPU_INTEL__
        push    af
    ENDIF
expl:
    IF  __CPU_INTEL__
        pop     af
    ENDIF
        push    hl
        push    af
        ld      a, SOUND_ONEBIT_mask
        ld      h, 0
        and     (hl)
        ld      l, a
        pop     af
        xor     l

        ONEBITOUT

        pop     hl

        push    af
        ld      b, h
        ld      c, l
dly:
        dec     bc
        ld      a, b
        or      c
        jr      nz, dly
        pop     af

        inc     hl
    IF  __CPU_INTEL__
        push    af
        xor     a
        add     h
    ELSE
        bit     1, h
    ENDIF
        jr      z, expl

    IF  __CPU_INTEL__
        pop     af
    ENDIF

        call    bit_close_ei
        ret


  ENDIF
