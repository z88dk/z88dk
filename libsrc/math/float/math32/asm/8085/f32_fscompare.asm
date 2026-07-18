;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_compare / m32_compare_callee - 8085 IEEE float compare
;-------------------------------------------------------------------------
; Stack only (no BSS).
; Exit: Z=equal, NZ=unequal, C=left<right, NC=left>=right, HL=1
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_compare, m32_compare_callee


; SP: rt, rr, ll, lh, rl, rh
.m32_compare
    ld de,sp+8
    call push_float_at
    ld de,sp+8
    call push_float_at
    call cmp_lr
    push af
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    pop af
    ld hl,1
    ret


; DEHL=right; SP: rt, rr, ll, lh
.m32_compare_callee
    push de
    push hl
    ; SP: right L,H,E,D, rt, rr, ll, lh
    ld de,sp+8
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    push hl
    push bc
    ; SP: left, right, rt, rr, ll, lh
    call cmp_lr
    push af
    pop bc
    pop af
    pop af
    pop af
    pop af
    pop de
    pop hl
    pop af
    pop af
    push hl
    push de
    push bc
    pop af
    ld hl,1
    ret


.push_float_at
    pop hl
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de
    ld a,(de)
    push hl
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    pop de
    push hl
    push bc
    push de
    ret


; SP: ret, left L,H,E,D, right L,H,E,D
.cmp_lr
    ld de,sp+8
    ld a,(de)
    ld c,a
    ld de,sp+9
    ld a,(de)
    ld d,a
    ld e,c
    call exp_zero
    jp Z,lr_rz

    ld de,sp+4
    ld a,(de)
    ld c,a
    ld de,sp+5
    ld a,(de)
    ld d,a
    ld e,c
    call exp_zero
    jp Z,lr_lz

    ; xform right at +6..+9
    ld de,sp+6
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld d,a
    ld e,c
    call xform
    ld bc,de
    ld a,l
    ld de,sp+6
    ld (de),a
    ld a,h
    ld de,sp+7
    ld (de),a
    ld a,c
    ld de,sp+8
    ld (de),a
    ld a,b
    ld de,sp+9
    ld (de),a

    ; xform left at +2..+5
    ld de,sp+2
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld d,a
    ld e,c
    call xform
    ld bc,de
    ld a,l
    ld de,sp+2
    ld (de),a
    ld a,h
    ld de,sp+3
    ld (de),a
    ld a,c
    ld de,sp+4
    ld (de),a
    ld a,b
    ld de,sp+5
    ld (de),a

    ; left - right
    ld de,sp+2
    ld a,(de)
    ld de,sp+6
    push af
    ld a,(de)
    ld h,a
    pop af
    sub h
    ld c,a
    ld de,sp+3
    ld a,(de)
    ld de,sp+7
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld b,a
    ld de,sp+4
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld l,a
    ld de,sp+5
    ld a,(de)
    ld de,sp+9
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    jp C,lr_neg
    or l
    or b
    or c
    ret

.lr_rz
    ld de,sp+4
    ld a,(de)
    ld c,a
    ld de,sp+5
    ld a,(de)
    ld d,a
    ld e,c
    call exp_zero
    jp Z,lr_eq
    ld de,sp+5
    ld a,(de)
    rla
    jp NC,lr_pos
    jp lr_neg

.lr_lz
    ld de,sp+9
    ld a,(de)
    rla
    jp NC,lr_neg
    jp lr_pos

.lr_eq
    xor a
    ret

.lr_pos
    ld a,1
    or a
    ret

.lr_neg
    ld a,1
    or a
    scf
    ret


.exp_zero
    ld a,d
    and 07fh
    ret NZ
    ld a,e
    and 080h
    ret


.xform
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    ccf
    jp C,xf_pos
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
.xf_pos
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,l
    and 0feh
    ld l,a
    ret
