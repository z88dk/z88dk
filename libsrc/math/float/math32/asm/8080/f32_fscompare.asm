;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_compare / m32_compare_callee - 8080 IEEE float compare
;-------------------------------------------------------------------------
; Sign/magnitude + high-word first early-out + no left-copy on callee.
;
; Exit: Z=equal, NZ=unequal, C=left<right, NC=left>=right, HL=1
;
; Frame access via ld hl,sp+n and ld r,(hl).  No ld de,sp+* / ld hl,(de).
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_compare, m32_compare_callee


.m32_compare
    ld hl,sp+8
    call push_float_at
    ld hl,sp+8
    call push_float_at
    call cmp_lr_copies
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


.m32_compare_callee
    push de
    push hl
    call cmp_lr_callee
    push af
    pop bc
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
    ; HL = pointer to IEEE float (LSW then MSW)
    pop bc
    ld e,(hl+)
    ld d,(hl+)
    push de                     ; LSW
    ld e,(hl+)
    ld d,(hl)
    pop hl                      ; HL = LSW
    push de                     ; MSW
    push hl                     ; LSW on top
    push bc
    ret


; SP: ret, L.L, L.H, R.L, R.H
.cmp_lr_copies
    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)
    call exp_zero
    jp Z,cp_rz

    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    call exp_zero
    jp Z,cp_lz

    ld hl,sp+5
    ld b,(hl)                       ; L.sign|exp
    ld hl,sp+9
    ld a,(hl)                       ; R.sign|exp
    ld c,a
    xor b
    and 080h
    jp NZ,cp_dsign

    ld a,b
    rla
    jp C,cp_neg
    ; both +: high first L.H - R.H
    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)                       ; DE = L.H
    ld hl,sp+8
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld hl,sp+2
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+6
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    ld b,a
    or c
    ret

.cp_neg
    ; both -: high first R.H - L.H
    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+4
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+2
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    ld b,a
    or c
    ret

.cp_dsign
    ld a,b
    rla
    jp C,lr_neg
    jp lr_pos


; SP: ret, R.L, R.H, rt, rr, L.L, L.H
.cmp_lr_callee
    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    call exp_zero
    jp Z,cc_rz

    ld hl,sp+12
    ld e,(hl+)
    ld d,(hl)
    call exp_zero
    jp Z,cc_lz

    ld hl,sp+13
    ld b,(hl)                       ; R.sign|exp
    ld hl,sp+5
    ld a,(hl)                       ; L.sign|exp
    ld c,a
    xor b
    and 080h
    jp NZ,cc_dsign

    ld a,b
    rla
    jp C,cc_neg
    ld hl,sp+12
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+4
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld hl,sp+10
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+2
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    ld b,a
    or c
    ret

.cc_neg
    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+12
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld hl,sp+2
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+10
    ld a,e
    sub (hl)
    ld c,a
    inc hl
    ld a,d
    sbc a,(hl)
    ld b,a
    or c
    ret

.cc_dsign
    ld a,b
    rla
    jp C,lr_neg
    jp lr_pos


.hi_fin
    jp C,lr_neg
    or c
    ret


.cp_rz
    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    call exp_zero
    jp Z,lr_eq
    ld hl,sp+5
    ld a,(hl)
    rla
    jp NC,lr_pos
    jp lr_neg

.cp_lz
    ld hl,sp+9
    ld a,(hl)
    rla
    jp NC,lr_neg
    jp lr_pos

.cc_rz
    ld hl,sp+12
    ld e,(hl+)
    ld d,(hl)
    call exp_zero
    jp Z,lr_eq
    ld hl,sp+13
    ld a,(hl)
    rla
    jp NC,lr_pos
    jp lr_neg

.cc_lz
    ld hl,sp+5
    ld a,(hl)
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
