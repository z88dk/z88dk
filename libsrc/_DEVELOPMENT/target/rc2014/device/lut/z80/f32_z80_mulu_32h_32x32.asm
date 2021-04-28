;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF __CPU_Z80__

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_32x32

;------------------------------------------------------------------------------
;
; feilipu, 2021 April
;
; multiplication of two 32-bit numbers into the high bytes of 64-bit product
;
;
; enter : dehl  = 32-bit multiplicand  = x
;         dehl' = 32-bit multiplier = y
;
; exit  : dehl = 32-bit product
;         carry reset
;
; uses  : af, bc, de, hl, af', bc', de', hl'

IF __IO_LUT_MODULE_AVAILABLE == 0

.m32_mulu_32h_32x32

    push de                     ; preserve multiplicand
    push hl
    exx

    push de                     ; preserve multiplier
    push hl

    ld a,l                      ; set up first multiplier from l
    exx

    ex de,hl
    ld b,h
    ld c,l                      ; l' * dehl (a*bcde)
    call mulu_40_32x8           ; result in abcde

    ld e,d                      ; shift result down 8 bits
    ld d,c
    ld c,b
    ld b,a
    exx

    pop af                      ; set up second multiplier from h
    pop hl                      ; recover multiplier msb de

    pop de                      ; recover multiplicand
    pop bc
    push bc
    push de

    push hl                     ; preserve multiplier msb de

                                ; h' * dehl (a*bcde)
    call mulu_40_32x8           ; result in abcde

    push bc
    push de
    exx

    pop hl                      ; sum terms
    add hl,de
    ex de,hl

    pop hl
    adc hl,bc
    ld b,h
    ld c,l

    adc a,0

    ld e,d                      ; shift result down 8 bits
    ld d,c
    ld c,b
    ld b,a
    exx

    pop hl                      ; set up third multiply from e

    pop de                      ; recover multiplicand
    pop bc
    push bc
    push de

    push hl                     ; preserve multiplier msb de

    ld a,l                      ; e' * dehl (a*bcde)
    call mulu_40_32x8           ; result in abcde

    push bc
    push de
    exx

    pop hl                      ; sum terms
    add hl,de
    ex de,hl

    pop hl
    adc hl,bc
    ld b,h
    ld c,l

    adc a,0

    ld e,d                      ; shift result down 8 bits
    ld d,c
    ld c,b
    ld b,a
    exx

    pop af                      ; set up fourth multiplier from d

    pop de                      ; recover multiplicand
    pop bc

                                ; d' * dehl (a*bcde)
    call mulu_40_32x8           ; result in abcde

    push bc
    push de
    exx

    pop hl                      ; sum terms
    add hl,de
    ex de,hl

    pop hl
    adc hl,bc

    adc a,0                     ; result in ahlde

    ld e,d                      ; shift result down 8 bits
    ld d,l
    ld l,h
    ld h,a

    ex de,hl

    ret                         ; exit  : DEHL = 32-bit product



.mulu_40_32x8

    ; enter :   bcde = 32-bit multiplicand
    ;              a = 8-bit multiplier
    ;
    ; exit  :  abcde = 40-bit result
    ;
    ; preserved: bc', de'
    ; uses  : af, bc, de, hl, hl'

    ; zero multiplier ?

    or a
    jr Z,exit_zero

    ; setup multiply

    push de

    ld h,b
    ld l,c
    ld d,b
    ld e,c

    exx

    pop hl

    push bc     ; preserve bc'
    push de     ; preserve de'

    ld d,h
    ld e,l

    ;  de'de = 32-bit multiplicand
    ;  hl'hl = 32-bit multiplicand, replicated
    ;      a = 8-bit multiplier

    ld c,0

    ; eliminate leading zeroes

.loop_00

    add a,a
    jr C,loop_11

    add a,a
    jr C,loop_12

    add a,a
    jr C,loop_13

    add a,a
    jr C,loop_14

    add a,a
    jr C,loop_15

    add a,a
    jr C,loop_16

    add a,a
    jr C,loop_17

    add a,a
    jr C,exit_18

.exit_zero
    xor a
    ld b,a
    ld c,a
    ld d,a
    ld e,a
    ret


.loop_11

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,loop_12

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.loop_12

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,loop_13

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.loop_13

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,loop_14

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.loop_14

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,loop_15

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.loop_15

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,loop_16

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.loop_16

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,loop_17

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.loop_17

    add hl,hl
    exx
    adc hl,hl
    exx
    adc a,a

    jr NC,exit_18

    add hl,de
    exx
    adc hl,de
    exx
    adc a,c

.exit_18

    ; ahl'hl = product
    exx

    pop de      ; restore de'
    pop bc      ; restore bc'

    push hl
    exx

    pop bc
    ex de,hl

    ; product in abcde
    ret

ELSE ;  feilipu, 2020 February

    ; start doing the p3 byte

    pop hl                      ; y3 y2

;;; MLT DL (BC) ;;;;;;;;;;;;;;;;; x1*y2
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;; MLT HE (BC) ;;;;;;;;;;;;;;;;; y3*x0
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a                       ; zero A
    add hl,de                   ; p4 p3
    adc a,a                     ; p5
    ex af,af

    pop bc                      ; x3 x2
    pop de                      ; y1 y0
    ld a,b
    ld b,d
    ld d,a
    push bc                     ; y1 x2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x3*y0
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ex af,af
    add hl,de                   ; p4 p3
    adc a,0                     ; p5
    pop de                      ; y1 x2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y1*x2
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
    add hl,de                   ; p4 p3
    adc a,0                     ; p5

    ex af,af
    ld a,l                      ; preserve p3 byte for rounding
    ex af,af

    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p5 p4

    ; start doing the p4 byte

    pop bc                      ; x1 y1
    pop de                      ; x3 y3
    ld a,b
    ld b,d
    ld d,a
    push bc                     ; x3 y1
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x1*y3
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a                       ; zero A
    add hl,de                   ; p5 p4
    adc a,a                     ; p6
    pop de                      ; x3 y1
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x3*y1
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p5 p4
    adc a,0                     ; p6

    pop de                      ; x2 y2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x2*y2
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p5 p4
    adc a,0                     ; p6

    ld c,l                      ; final p4 byte in C
    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p6 p5

    ex af,af                    ; p3 byte for rounding
    or a
    jr Z,mul0                   ; use p3 to round p4
    set 0,c

.mul0
    ; start doing the p5 byte

    pop de                      ; y3 x2
    push bc                     ; save p4 byte

;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y3*x2
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a                       ; zero A
    add hl,de                   ; p6 p5
    adc a,a                     ; p7

    pop bc                      ; save p4 byte
    pop de                      ; x3 y2
    push bc                     ; save p4 byte

;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x3*y2
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p6 p5
    adc a,0                     ; p7

    pop bc                      ; save p4 byte in C
    ld b,l                      ; final p5 byte in B
    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p7 p6

    ; start doing the p6 p7 bytes

    pop de                      ; y3 x3
    push bc                     ; save p5 p4 byte in BC

;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y3*x3
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p7 p6 in HL
    pop de                      ; save p5 p4 byte in DE
    ex de,hl                    ; p7 p6 p5 p4
    ret                         ; exit  : DEHL = 32-bit product

ENDIF
ENDIF
