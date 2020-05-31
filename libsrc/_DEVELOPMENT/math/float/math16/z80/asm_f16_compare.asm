;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, May 2020
;
;-------------------------------------------------------------------------
;  asm_f16_compare - z80 comparision code
;-------------------------------------------------------------------------
;
;       return:    Z = number is zero
;               (NZ) = number is non-zero
;                  C = number is negative 
;                 NC = number is positive
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN  asm_f16_f24
EXTERN  asm_f24_f32

PUBLIC  asm_f16_compare, asm_f16_compare_callee

; Compare two IEEE half floats.
;
; IEEE half float is considered zero if exponent is zero.
;
; To compare our floating point numbers across whole number range,
; we define the following rules:
;       - Always flip the sign bit.
;       - If the sign bit was set (negative), flip the other bits too.
;       http://stereopsis.com/radix.html, et al.
;
;
;       Entry: stack = right, left, ret, ret
;
;       Exit:      Z = number is zero
;               (NZ) = number is non-zero
;                  C = number is negative 
;                 NC = number is positive
;              stack = right, left, ret
;
;       Uses: af, bc, de, hl, bc', de', hl'
.asm_f16_compare
    pop bc              ;return address from this function
    pop de              ;return address to real program
    pop hl              ;the left (primary) off the stack
    exx                 ;right
    pop hl              ;and the right (secondary) off the stack
    push hl
    exx                 ;left
    push hl
    push de
    push bc
    jr continue

;       Entry:   hl  = right
;              stack = left, ret, ret
;
;       Exit:      Z = number is zero
;               (NZ) = number is non-zero
;                  C = number is negative 
;                 NC = number is positive
;
;       Uses: af, bc, de, hl, bc', de', hl'
.asm_f16_compare_callee
    exx                 ;left
    pop bc              ;return address from this function
    pop de              ;return address to real program
    pop hl              ;and the left (primary) off the stack
    push de
    push bc

.continue
    exx                 ;right
    call asm_f16_f24
    call asm_f24_f32
    sla e
    rl d
    jr Z,zero_right     ;right is zero (exponent is zero)
    ccf
    jr C,positive_right
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
.positive_right
    rr d
    rr e

    exx                 ;left
    call asm_f16_f24
    call asm_f24_f32
    sla e
    rl d
    jr Z,zero_left      ;left is zero (exponent is zero)
    ccf
    jr C,positive_left
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
.positive_left
    rr d
    rr e

    ld a,l

    exx                 ;right
    sub l
    ld c,a

    exx                 ;left
    ld a,h

    exx                 ;right
    sbc a,h
    ld b,a

    exx                 ;left
    ld a,e

    exx                 ;right
    sbc a,e

    exx                 ;left
    ld c,a
    ld a,d

    exx                 ;right
    sbc a,d

    ; dehl  = right float, bc   =  low word of result
    ; dehl' =  left float, a,c' = high word of result
    jr C,consider_negative

.consider_positive
    ; Calculate whether result is zero (equal)
    or c
    or b
    exx                 ;left
    or c
.return_positive
    ld hl,1
    scf
    ccf
    ret

.consider_negative
    ; Calculate whether result is zero (equal)
    or c
    or b
    exx                 ;left
    or c
.return_negative
    ld hl,1
    scf
    ret

.zero_right
    ;   right dehl = 0    
    ;   left dehl' = float
    exx                 ;left
    sla e
    rl d
    jr NC,return_positive
    jr Z,return_positive    ;both left and right are zero
    jr return_negative

.zero_left
    ;   left dehl = 0
    ;   right dehl' = (cpl if negative)float non-zero
    exx                 ;right
    sla e
    rl d
    jr NC,return_positive
    jr return_negative

