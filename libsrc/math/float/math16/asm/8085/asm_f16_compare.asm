;
;  feilipu, May 2020 / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_compare - 8085 comparison code
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f16_compare
PUBLIC asm_f16_compare_callee

; stack top-first: this_ret, real_ret, left, right
.asm_f16_compare
    pop bc                      ; this
    pop de                      ; real
    pop hl                      ; left
    ex (sp),hl                  ; HL = right; (sp) = left
    push de                     ; real
    push bc                     ; this
    ; stack: this, real, left; HL = right
    push hl                     ; save right
    ld de,sp+6                  ; left @+4, +2 after push
    ld hl,(de)                  ; HL = left
    pop de                      ; DE = right
    jr continue

; HL = right; stack after call: this_ret, real_ret, left, ...
.asm_f16_compare_callee
    pop bc                      ; this
    pop de                      ; real
    ; HL=right, stack=left
    ex de,hl                    ; DE=right, HL=real
    ex (sp),hl                  ; HL=left, (sp)=real
    push bc                     ; this on top of real
    ; HL=left, DE=right, stack: this, real, ...

.continue
    ld a,$7c
    and d
    jr Z,zero_right

    ld a,d
    add a,a
    ld d,a
    ccf
    jr C,positive_right
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
.positive_right
    ld a,d
    rra
    ld d,a
    ld a,e
    and 0feh
    ld e,a

    ld a,$7c
    and h
    jr Z,zero_left

    ld a,h
    add a,a
    ld h,a
    ccf
    jr C,positive_left
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
.positive_left
    ld a,h
    rra
    ld h,a
    ld a,l
    and 0feh
    ld l,a

    ld bc,de
    or a
    sub hl,bc
    jr C,consider_negative

.consider_positive
    ld a,h
    or l
.return_positive
    ld hl,1
    scf
    ccf
    ret

.consider_negative
    ld a,h
    or l
.return_negative
    ld hl,1
    scf
    ret

.zero_right
    ld a,$7c
    and h
    jr Z,return_positive
    ld a,h
    add a,a
    jr NC,return_positive
    jr return_negative

.zero_left
    ld a,d
    add a,a
    jr NC,return_positive
    jr return_negative
