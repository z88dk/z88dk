;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_am9511_compare_sccz80

; Compare two IEEE floats.
;
; IEEE float is considered zero if exponent is zero.
;
; To compare our floating point numbers across whole number range,
; we define the following rules:
;       - Always flip the sign bit.
;       - If the sign bit was set (negative), flip the other bits too.
;       http://stereopsis.com/radix.html, et al.

;       Entry: stack = left, right, ret, ret
;
;       Exit:      Z = number is zero
;               (NZ) = number is non-zero
;                  C = number is negative
;                 NC = number is positive
;
;       NOTE: Changes (mutates) the input stack parameters!
;
;       Uses: af, bc, de, hl
.asm_am9511_compare_sccz80
    ld de,sp+4          ;right
    ex de,hl
    ld de,sp+8          ;left

;       We subtract the right from the left.
;                       l-r -> result
;                       (hl) right
;                       (de) left

    push hl             ;(hl) right
    push de             ;(de) left
    push de             ;(de) left
    ld bc,hl            ;(bc) right

    ld de,hl+2          ;(de) right MSW
    ld hl,(de)          ;right MSW
    add hl,hl
    inc h
    dec h
    jp Z,zero_right     ;right is zero (exponent is zero)

    jp NC,positive_right

    ld a,(bc)           ;flip all right bits
    cpl
    ld (bc),a
    inc bc
    ld a,(bc)
    cpl
    ld (bc),a
    inc bc
    ld a,(bc)
    cpl
    ld (bc),a
    inc bc
    ld a,(bc)
    cpl
    ld (bc),a
    jp continue_left

.positive_right
    inc de
    ld a,(de)
    xor 080h             ;flip right sign bit
    ld (de),a

.continue_left
    pop hl              ;(hl) left
    ld bc,hl            ;(bc) left

    ld de,hl+2          ;(de) left MSW
    ld hl,(de)          ;left MSW
    add hl,hl
    inc h
    dec h
    jp Z,zero_left      ;left is zero (exponent is zero)

    jp NC,positive_left

    ld a,(bc)           ;flip all left bits
    cpl
    ld (bc),a
    inc bc
    ld a,(bc)
    cpl
    ld (bc),a
    inc bc
    ld a,(bc)
    cpl
    ld (bc),a
    inc bc
    ld a,(bc)
    cpl
    ld (bc),a
    jp continue

.positive_left
    inc de
    ld a,(de)
    xor 080h           ;flip left sign bit
    ld (de),a

.continue
    pop bc              ;(bc) left
    pop hl              ;(hl) right

    push de             ;make working variable
    push de
    ld de,sp+0          ;(de) pointer to variable

    ld a,(bc)           ;left
    sub (hl)            ;right
    ld (de),a           ;result

    inc bc
    inc de
    inc hl

    ld a,(bc)           ;left
    sbc (hl)            ;right + C
    ld (de),a           ;result

    inc bc
    inc de
    inc hl

    ld a,(bc)           ;left
    sbc (hl)            ;right + C
    ld (de),a           ;result

    inc bc
;   inc de
    inc hl

    ld a,(bc)           ;left
    sbc (hl)            ;right + C
;   ld (de),a           ;leave MSB in a

    jp C,consider_negative

.consider_positive
    ; Calculate whether result is zero (equal)
    ex de,hl
;   dec hl
    or (hl)
    dec hl
    or (hl)
    dec hl
    or (hl)

    pop bc              ;remove working variable
    pop bc

.return_positive
    ld hl,1
    scf
    ccf
    ret

.consider_negative
    ; Calculate whether result is zero (equal)
    ex de,hl
;   dec hl
    or (hl)
    dec hl
    or (hl)
    dec hl
    or (hl)

    pop bc              ;remove working variable
    pop bc

.return_negative
    ld hl,1
    scf
    ret

.zero_right
    pop hl              ;(hl) left
    pop hl              ;(hl) left
    pop bc              ;(bc) right

    ld de,hl+2          ;(de) left MSW
    ld hl,(de)          ;left MSW
    add hl,hl
    inc h
    dec h

    jp NC,return_positive
    jp Z,return_positive    ;both left and right are zero
    jp return_negative

.zero_left
    pop bc              ;(bc) left
    pop hl              ;(hl) right

    ld de,hl+2          ;(de) right MSW
    ld hl,(de)          ;right MSW
    add hl,hl
    jp NC,return_positive
    jp return_negative

