;
; Generic version
; calibrated for a fixed bitrate, 1-bit ZX81
;
; Stefano Bodrato, Feb - 2025
;

;
;$Id: playzb4.asm $
;

; extern void __LIB__ playzb4(uchar *SamStart, ushort SamLen);
; play 4 bit pulse wave encoded data using sid master volume


IF  !__CPU_GBZ80__

    SECTION code_clib

    PUBLIC  playzb4
    PUBLIC  _playzb4

    EXTERN  bit_open_di
    EXTERN  bit_close_ei
    EXTERN  __snd_tick

    INCLUDE "classic/games/games.inc"


playzb4:
_playzb4:

    call    bit_open_di

    pop     bc
    pop     de                          ;sample length
    pop     hl                          ;sample start addr
    push    hl
    push    de
    push    bc

rep1:
    ld      a, (hl)                     ; a = sample byte
    rrca                                ; a = a div 16
    rrca                                ;
    rrca                                ;
    rrca                                ;
    and     $0f                         ; 4 bit nibble
    call    do_sound

    ld      a, (hl)                     ; a = sample byte
    and     $0f                         ; 4 bit nibble
    call    do_sound

    inc     hl                          ; hl = hl+1
    dec     e                           ;
    jr      nz, rep1                    ;
    dec     d                           ; de = de-1
    jr      nz, rep1                    ;until de = 0

    jp      bit_close_ei



do_sound:
    push    hl
	;push de
    ld      hl, _dithpat
    add     l
    ld      l, a
    ld      a, h
    adc     0
    ld      h, a

    ld      a, (hl)

;  LOOP UNROLLING !!
  IF    PLAY_DATA_LEAD>120
    ld      b, 4
  ELSE
    ld      b, 3
  ENDIF
byte1:
    out     (SOUND_ONEBIT_port), a
    rlca
    ld      l, a
    sbc     a, a                        ; 0 or FF
    out     (SOUND_ONEBIT_port), a      ; this extra instruction is only slowing down the loop

    jr      z,complement
    in      a, (SOUND_ZEROBIT_port)
complement:

    ld      a, l
    djnz    byte1

	;pop de
    pop     hl
    ret




    SECTION rodata_clib

_dithpat:

    defb    @00000000                   ; 0

    defb    @00000000                   ; 1

    defb    @00000000                   ; 2

    defb    @00000000                   ; 3

    defb    @00010000                   ; 4

    defb    @01000000                   ; 5

    defb    @00110000                   ; 6

    defb    @11000000                   ; 7

    defb    @10100000                   ; 8

    defb    @10100000                   ; 9

    defb    @11100000                   ; 10

    defb    @01110000                   ; 11

    defb    @11010000                   ; 12

    defb    @10110000                   ; 13

    defb    @11110000                   ; 14

    defb    @11110000                   ; 15

ENDIF
