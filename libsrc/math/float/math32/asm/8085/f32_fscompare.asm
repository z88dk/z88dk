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
; Sign/magnitude + high-word first early-out + no left-copy on callee.
;
; Exit: Z=equal, NZ=unequal, C=left<right, NC=left>=right, HL=1
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_compare, m32_compare_callee


.m32_compare
    ld de,sp+8
    call push_float_at
    ld de,sp+8
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
    pop bc
    ld hl,(de)
    inc de
    inc de
    push hl
    ld hl,(de)
    ex de,hl
    pop hl
    push de
    push hl
    push bc
    ret


; SP: ret, L.L, L.H, R.L, R.H
.cmp_lr_copies
    ld de,sp+8
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,cp_rz

    ld de,sp+4
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,cp_lz

    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+9
    ld a,(de)
    ld c,a
    xor b
    and 080h
    jp NZ,cp_dsign

    ld a,b
    rla
    jp C,cp_neg
    ; both +: high first L.H - R.H
    ld de,sp+4
    ld hl,(de)
    ld de,sp+8
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    jp NZ,hi_fin                        ; high differs
    or c
    jp NZ,hi_fin
    ; high equal — compare low L.L - R.L
    ld de,sp+2
    ld hl,(de)
    ld de,sp+6
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    ld b,a
    or c
    ret                                 ; C from sbc; Z if equal

.cp_neg
    ; both -: high first R.H - L.H
    ld de,sp+8
    ld hl,(de)
    ld de,sp+4
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld de,sp+6
    ld hl,(de)
    ld de,sp+2
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
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
    ld de,sp+4
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,cc_rz

    ld de,sp+12
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,cc_lz

    ld de,sp+13
    ld a,(de)
    ld b,a
    ld de,sp+5
    ld a,(de)
    ld c,a
    xor b
    and 080h
    jp NZ,cc_dsign

    ld a,b
    rla
    jp C,cc_neg
    ; both +: L.H@12 - R.H@4
    ld de,sp+12
    ld hl,(de)
    ld de,sp+4
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ; low L@10 - R@2
    ld de,sp+10
    ld hl,(de)
    ld de,sp+2
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    ld b,a
    or c
    ret

.cc_neg
    ; both -: R.H@4 - L.H@12
    ld de,sp+4
    ld hl,(de)
    ld de,sp+12
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld de,sp+2
    ld hl,(de)
    ld de,sp+10
    ld a,l
    ld b,h
    ld hl,(de)
    sub l
    ld c,a
    ld a,b
    sbc a,h
    ld b,a
    or c
    ret

.cc_dsign
    ld a,b
    rla
    jp C,lr_neg
    jp lr_pos


; A = high byte of high-word diff, C = low byte, flags from sbc of high
.hi_fin
    jp C,lr_neg
    or c                                ; NZ (high differed); OR clears C → NC
    ret


.cp_rz
    ld de,sp+4
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,lr_eq
    ld de,sp+5
    ld a,(de)
    rla
    jp NC,lr_pos
    jp lr_neg

.cp_lz
    ld de,sp+9
    ld a,(de)
    rla
    jp NC,lr_neg
    jp lr_pos

.cc_rz
    ld de,sp+12
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,lr_eq
    ld de,sp+13
    ld a,(de)
    rla
    jp NC,lr_pos
    jp lr_neg

.cc_lz
    ld de,sp+5
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
