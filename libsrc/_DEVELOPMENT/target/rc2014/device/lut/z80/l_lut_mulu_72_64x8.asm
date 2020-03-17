;
;  feilipu, 2020 January
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; Using RC2014 LUT Module
;
;------------------------------------------------------------------------------

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_lut_mulu_72_64x8

l_lut_mulu_72_64x8:

   ; multiplication of a 64-bit number and an 8-bit number into 72-bit result
   ;
   ; enter :   dehl'dehl = 64-bit multiplicand
   ;                   a = 8-bit multiplicand
   ;
   ; exit  : a dehl'dehl = 72-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'


    ld b,a                      ; 4  operand X in B

    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),l                   ; 12 operand Y0 from L
    in l,(c)                    ; 12 result LSB to A
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),h                   ; 12 operand Y1 from H
    in h,(c)                    ; 12 result LSB to H
    add a,h
    ld h,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand Y2 from E
    in e,(c)                    ; 12 result LSB to E
    adc a,e
    ld e,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),d                   ; 12 operand Y3 from D
    in d,(c)                    ; 12 result LSB to D
    adc a,d
    ld d,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    push bc

    exx
    pop bc

    dec c                       ; 4  operand latch address
    out (c),l                   ; 12 operand Y4 from L'
    in l,(c)                    ; 12 result LSB to L'
    adc a,l
    ld l,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),h                   ; 12 operand Y5 from H
    in h,(c)                    ; 12 result LSB to H
    adc a,h
    ld h,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand Y6 from E
    in e,(c)                    ; 12 result LSB to E
    adc a,e
    ld e,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),d                   ; 12 operand Y7 from D
    in d,(c)                    ; 12 result LSB to D
    adc a,d
    ld d,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A
    adc a,0                     ;    final carry

    exx
    ret
