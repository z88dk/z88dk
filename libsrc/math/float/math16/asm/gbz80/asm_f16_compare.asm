;
;  feilipu, May 2020 / 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_compare - gbz80 comparison code
;-------------------------------------------------------------------------
; Callee must consume left (sccz80 l_f16_*). Never pop af a return word.
; ex (sp),hl is 148c; compare entry only, not a hot loop.
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f16_compare
PUBLIC asm_f16_compare_callee

; stack: this, real, left, right  (args not consumed)
.asm_f16_compare
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a                      ; HL = left
    push hl
    ld hl,sp+8                  ; right was +6, +2 after push
    ld a,(hl+)
    ld h,(hl)
    ld l,a                      ; HL = right
    pop de                      ; DE = left
    push hl
    ld hl,de
    pop de                      ; HL=left DE=right
    jr continue

; HL=right, stack: this, real, left. Consume left.
.asm_f16_compare_callee
    ld de,hl                    ; DE = right
    pop bc                      ; this
    pop hl                      ; real (return; never pop af)
    ex (sp),hl                  ; HL = left; (sp) = real
    push bc                     ; this, real

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
    ld a,l
    sub c
    ld l,a
    ld a,h
    sbc a,b
    ld h,a
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
