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

SECTION code_fp_math16

PUBLIC asm_f16_compare
PUBLIC asm_f16_compare_callee

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
;               (NC) = number is positive
;              stack = right, left, ret
;
;       Uses: af, bc, de, hl
.asm_f16_compare
    pop af              ;return address from this function
    pop bc              ;return address to real program
    pop hl              ;the left (primary) off the stack
    pop de              ;and the right (secondary) off the stack
    push de
    push hl
    push bc
    push af
    jr continue

;       Entry:   h  = right
;              stack = left, ret, ret
;
;       Exit:      Z = number is zero
;               (NZ) = number is non-zero
;                  C = number is negative 
;                 NC = number is positive
;
;       Uses: af, bc, de, hl
.asm_f16_compare_callee
    pop af              ;return address from this function
    pop bc              ;return address to real program
    pop de              ;and the left (primary) off the stack
    push bc
    push af
    ex de,hl

.continue
;
;                 hl = primary (left)
;                 de = secondary (right)
;
    ld a,$7c            ;exponent mask
    and d
    jr Z,zero_right     ;right is zero (exponent is zero)
    sla d
    ccf
    jr C,positive_right
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
.positive_right
    rr d

    res 0,e             ;remove least significant bit

    ld a,$7c            ;exponent mask
    and h
    jr Z,zero_left      ;left is zero (exponent is zero)
    sla h
    ccf
    jr C,positive_left
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
.positive_left
    rr h

    res 0,l             ;remove least significant bit

    xor a
    sbc hl,de
    jr C,consider_negative

.consider_positive
    ; Calculate whether result is zero (equal)
    ld a,h
    or l
.return_positive
    ld hl,1
    scf
    ccf
    ret

.consider_negative
    ; Calculate whether result is zero (equal)
    ld a,h
    or l
.return_negative
    ld hl,1
    scf
    ret

.zero_right
    ;   right de = 0    
    ;   left  hl = half
    ld a,$7c                ;exponent mask
    and h
    jr Z,return_positive    ;both left and right are zero
    sla h
    jr NC,return_positive
    jr return_negative

.zero_left
    ;   left hl = 0
    ;   right de = (cpl if negative) non-zero
    sla d
    jr NC,return_positive
    jr return_negative

