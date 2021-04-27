;
;  feilipu, 2021 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF __CPU_Z80__

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_32x32

;------------------------------------------------------------------------------
;
; multiplication of two 32-bit numbers into the high bytes of 64-bit product
;
;
; enter : dehl  = 32-bit multiplicand  = x
;         dehl' = 32-bit multiplier = y
;
; exit  : dehl  = 32-bit product
;         carry reset
;
; uses  : af, bc, de, hl, af', bc', de', hl'


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

    sla e                       ; check for significant bit for rounding
    jr NC,no_rounding_l
    set 0,d

.no_rounding_l
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

    sla e                       ; check for significant bit for rounding
    jr NC,no_rounding_h
    set 0,d

.no_rounding_h
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

    sla e                       ; check for significant bit for rounding
    jr NC,no_rounding_e
    set 0,d

.no_rounding_e
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

    sla e                       ; check for significant bit for rounding
    jr NC,no_rounding_d
    set 0,d

.no_rounding_d
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

ENDIF
