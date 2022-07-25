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
; enter : dehl  = 32-bit multiplicand  = x   x1x0
;         dehl' = 32-bit multiplier    = y   y1y0
;
; exit  : dehl  = 32-bit product = z  z3z2 = y1y0 * x1x0
;         carry reset
;
; uses  : af, bc, de, hl, bc', de', hl'


.m32_mulu_32h_32x32

    push de                     ; preserve multiplicand x1
    push de                     ; x1
    exx

    pop bc                      ; x1
    push de                     ; preserve multiplier y1
    push bc                     ; x1

    push hl                     ; preserve multiplier y0
    push de                     ; preserve multiplier y1

    push hl                     ; preserve multiplier y0
    exx

    pop de                      ; y0
    push hl                     ; preserve multiplicand x0

    ; multiply lowest term y0*x0
    call mulu_32_16x16          ; de*hl -> dehl

    ex de,hl                    ; hlde z1 (partial)
    pop de                      ; x0
    ex (sp),hl                  ; y1 z1 (partial), abandon z0

    ; multiply middle term x0*y1
    call mulu_32_16x16          ; de*hl -> dehl

    pop bc
    add hl,bc                   ; z1 (partial)
    ld b,h
    ld c,l

    ld hl,0
    adc hl,de                   ; z2 (partial)
    ex de,hl
    exx                         ; z2z1 (partial) de'bc'

    pop de                      ; y0
    pop hl                      ; x1

    ; multiply middle term y0*x1
    call mulu_32_16x16          ; de*hl -> dehl

    push de
    push hl
    exx

    pop hl
    add hl,bc                   ; z1 capture carry and abandon

    pop hl
    adc hl,de                   ; z2 (partial)
    ex de,hl

    ld bc,0
    rl c                        ; z3 (partial)

    exx                         ; z3z2 (partial) bc'de'

    pop de                      ; y1
    pop hl                      ; x1

    ; multiply top term y1*x1
    call mulu_32_16x16          ; de*hl -> dehl

    push de
    push hl
    exx

    pop hl
    add hl,de
    ex de,hl                    ; z2

    pop hl
    adc hl,bc                   ; z3

    ex de,hl                    ; z3z2 dehl

    ret                         ; exit  : DEHL = 32-bit product


; Made by Runer112
; Analysed by Zeda
; https://raw.githubusercontent.com/Zeda/z80float/master/common/mul16.z80
; Tested by jacobly
;
; DE*HL --> DEHL
;
; enter : de   = 16-bit multiplicand  = x
;         hl   = 16-bit multiplier = y
;
; exit  : dehl = 32-bit product
;
; uses  : af, bc, de, hl

.mulu_32_16x16

    ld a,d
    ld d,0
    ld b,h
    ld c,l

    add a,a
    jr C,bit14
    add a,a
    jr C,bit13
    add a,a
    jr C,bit12
    add a,a
    jr C,bit11
    add a,a
    jr C,bit10
    add a,a
    jr C,bit9
    add a,a
    jr C,bit8
    add a,a
    jr C,bit7

    ld a,e
    and %11111110
    add a,a
    jr C,bit6
    add a,a
    jr C,bit5
    add a,a
    jr C,bit4
    add a,a
    jr C,bit3
    add a,a
    jr C,bit2
    add a,a
    jr C,bit1
    add a,a
    jr C,bit0
    rr e
    ret C

    ld h,d
    ld l,e
    ret

.bit14
    add hl,hl
    adc a,a
    jr NC,bit13
    add hl,bc
    adc a,d

.bit13
    add hl,hl
    adc a,a
    jr NC,bit12
    add hl,bc
    adc a,d

.bit12
    add hl,hl
    adc a,a
    jr NC,bit11
    add hl,bc
    adc a,d

.bit11
    add hl,hl
    adc a,a
    jr NC,bit10
    add hl,bc
    adc a,d

.bit10
    add hl,hl
    adc a,a
    jr NC,bit9
    add hl,bc
    adc a,d

.bit9
    add hl,hl
    adc a,a
    jr NC,bit8
    add hl,bc
    adc a,d

.bit8
    add hl,hl
    adc a,a
    jr NC,bit7
    add hl,bc
    adc a,d

.bit7
    ld d,a
    ld a,e
    and %11111110
    add hl,hl
    adc a,a
    jr NC,bit6
    add hl,bc
    adc a,0

.bit6
    add hl,hl
    adc a,a
    jr NC,bit5
    add hl,bc
    adc a,0

.bit5
    add hl,hl
    adc a,a
    jr NC,bit4
    add hl,bc
    adc a,0

.bit4
    add hl,hl
    adc a,a
    jr NC,bit3
    add hl,bc
    adc a,0

.bit3
    add hl,hl
    adc a,a
    jr NC,bit2
    add hl,bc
    adc a,0

.bit2
    add hl,hl
    adc a,a
    jr NC,bit1
    add hl,bc
    adc a,0

.bit1
    add hl,hl
    adc a,a
    jr NC,bit0
    add hl,bc
    adc a,0

.bit0
    add hl,hl
    adc a,a
    jr C,funkyCarry
    rr e
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret NZ
    inc d
    ret

.funkyCarry
    inc d
    rr e
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret

ENDIF
