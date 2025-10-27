;
;  feilipu, 2021 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF __CPU_Z80__ | __CPU_KC160__

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_24x24, m32_l0_mulu_32h_24x24

;------------------------------------------------------------------------------
;
; multiplication of two 24-bit numbers into a 32-bit high product
;
; result is calculated for highest 32-bit result
; from a 48-bit calculation.
;
; lower 8 bits intended to provide rounding information for
; IEEE floating point 24-bit mantissa calculations.
;
; enter :  lde  = 24-bit multiplicand = x
;          lde' = 24-bit multiplier   = y
;
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl, bc', de', hl'


.m32_mulu_32h_24x24

    push hl                     ; preserve multiplicand
    push de
    exx

    push hl                     ; preserve multiplier
    push de

    ld a,e                      ; set up first multiplier from e
    exx

.m32_l0_mulu_32h_24x24

    ld c,l                      ; e' * lde (a*cde)
    call mulu_32_24x8           ; result in bcde

    ld e,d                      ; shift result down 8 bits
    ld d,c
    ld c,b
    ld b,0
    exx

    pop af                      ; set up second multiplier from d
    pop hl                      ; recover multiplier msb l

    pop de                      ; recover multiplicand
    pop bc
    push bc
    push de

    push hl                     ; preserve multiplier msb l

                                ; d' * lde (a*cde)
    call mulu_32_24x8           ; result in bcde

    push bc
    push de
    exx

    pop hl                      ; sum terms
    add hl,de
    ex de,hl

    pop hl
    adc hl,bc

    ld e,d                      ; shift result down 8 bits
    ld d,l
    ld c,h
    ld b,0
    exx

    pop hl                      ; set up third multiply from l

    pop de                      ; recover multiplicand
    pop bc

    ld a,l                      ; l' * lde (a*cde)
    call mulu_32_24x8           ; result in bcde

    push bc
    push de
    exx

    pop hl                      ; sum terms
    add hl,de
    ex de,hl

    pop hl
    adc hl,bc

    ret                         ; exit  : HLDE  = 32-bit high product


.mulu_32_24x8

    ;  cde = 24-bit multiplicand
    ;    a = 8-bit multiplier
    ;
    ; bcde = 32-bit result
    ;
    ; uses  : af, bc, de, hl

    ; zero multiplier ?

    or a
    jr Z,exit_zero

    ; setup multiply

    ld b,a

    ld a,c
    ld h,d
    ld l,e

    ; eliminate leading zero bits

.loop_00

    sla b
    jr C,loop_11

    sla b
    jr C,loop_12

    sla b
    jr C,loop_13

    sla b
    jr C,loop_14

    sla b
    jr C,loop_15

    sla b
    jr C,loop_16

    sla b
    jr C,loop_17

    sla b
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
    rla
    rl b

    jr NC,loop_12

    add hl,de
    adc a,c

    jp NC,loop_12
    inc b

.loop_12

    add hl,hl
    rla 
    rl b

    jr NC,loop_13

    add hl,de
    adc a,c

    jp NC,loop_13
    inc b

.loop_13

    add hl,hl
    rla 
    rl b

    jr NC,loop_14

    add hl,de
    adc a,c

    jp NC,loop_14
    inc b

.loop_14

    add hl,hl
    rla 
    rl b

    jr NC,loop_15

    add hl,de
    adc a,c

    jp NC,loop_15
    inc b

.loop_15

    add hl,hl
    rla 
    rl b

    jr NC,loop_16

    add hl,de
    adc a,c

    jp NC,loop_16
    inc b

.loop_16

    add hl,hl
    rla 
    rl b

    jr NC,loop_17

    add hl,de
    adc a,c

    jp NC,loop_17
    inc b

.loop_17

    add hl,hl
    rla 
    rl b

    jr NC,exit_18

    add hl,de
    adc a,c

    jp NC,exit_18
    inc b

.exit_18

    ; product in bahl
    ld c,a
    ex de,hl

    ; product in bcde
    ret

ENDIF
