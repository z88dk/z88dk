;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_compare / m32_compare_callee - vm1 IEEE float compare
;-------------------------------------------------------------------------
;
; Sign/magnitude + high-word first early-out + no left-copy on callee.
;
; Exit: Z=equal, NZ=unequal, C=left<right, NC=left>=right, HL=1
;
; Word loads: LHLX. 16-bit order: cp hl,de (high) / sub hl,de (low).
; Frame address through HL (no LDSI). No unknown pop af.

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_compare, m32_compare_callee


.m32_compare
    ld hl,8
    add hl,sp
    call push_float_at
    ld hl,8
    add hl,sp
    call push_float_at
    call cmp_lr_copies
    push af
    pop bc
    pop de
    pop de
    pop de
    pop de                          ; drop L/R copies
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
    pop de
    pop de                          ; drop R copies
    pop de                          ; orig ret
    pop hl
    inc sp
    inc sp
    inc sp
    inc sp                          ; drop leftover (ret in DE, HL live)
    push hl
    push de
    push bc
    pop af
    ld hl,1
    ret


.push_float_at
    ; HL = pointer to IEEE float (LSW then MSW)
    pop bc
    ex de,hl
    ld hl,(de)                      ; LSW
    inc de
    inc de
    push hl
    ld hl,(de)                      ; MSW
    ex de,hl
    pop hl
    push de
    push hl
    push bc
    ret


; SP: ret, L.L, L.H, R.L, R.H
.cmp_lr_copies
    ld hl,8
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl                        ; DE = L.H
    call exp_zero
    jp Z,cp_rz

    ld hl,4
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl                        ; DE = L.H
    call exp_zero
    jp Z,cp_lz

    ld hl,5
    add hl,sp
    ld b,(hl)                       ; L.sign|exp
    ld hl,9
    add hl,sp
    ld a,(hl)                       ; R.sign|exp
    ld c,a
    xor b
    and 080h
    jp NZ,cp_dsign

    ld a,b
    rla
    jp C,cp_neg
    ; both +: L.H vs R.H
    ld hl,4
    add hl,sp
    ex de,hl
    ld hl,(de)                      ; HL = L.H
    push hl
    ld hl,10                        ; R.H at +8 +2
    add hl,sp
    ex de,hl
    ld hl,(de)                      ; HL = R.H
    pop de
    ex de,hl                        ; HL = L.H, DE = R.H
    cp hl,de
    jp Z,cp_low
    jp C,lr_neg
    jp lr_pos

.cp_low
    ld hl,2
    add hl,sp
    ex de,hl
    ld hl,(de)                      ; L.L
    push hl
    ld hl,8                         ; R.L at +6 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl                        ; HL = L.L, DE = R.L
    sub hl,de
    jp C,lr_neg
    ld a,h
    or l
    ret

.cp_neg
    ; both -: R.H vs L.H
    ld hl,8
    add hl,sp
    ex de,hl
    ld hl,(de)
    push hl
    ld hl,6                         ; L.H at +4 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl                        ; HL = R.H, DE = L.H
    cp hl,de
    jp Z,cp_low_neg
    jp C,lr_neg
    jp lr_pos

.cp_low_neg
    ld hl,6
    add hl,sp
    ex de,hl
    ld hl,(de)                      ; R.L
    push hl
    ld hl,4                         ; L.L at +2 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl
    sub hl,de
    jp C,lr_neg
    ld a,h
    or l
    ret

.cp_dsign
    ld a,b
    rla
    jp C,lr_neg
    jp lr_pos


; SP: ret, R.L, R.H, rt, rr, L.L, L.H
.cmp_lr_callee
    ld hl,4
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl                        ; DE = R.H
    call exp_zero
    jp Z,cc_rz

    ld hl,12
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl                        ; DE = L.H
    call exp_zero
    jp Z,cc_lz

    ld hl,13
    add hl,sp
    ld b,(hl)                       ; R.sign|exp
    ld hl,5
    add hl,sp
    ld a,(hl)                       ; L.sign|exp
    ld c,a
    xor b
    and 080h
    jp NZ,cc_dsign

    ld a,b
    rla
    jp C,cc_neg
    ; callee both +: left is L at +10/+12, right is R at +2/+4
    ; original compared L.H (sp+12) - R.H (sp+4)
    ld hl,12
    add hl,sp
    ex de,hl
    ld hl,(de)
    push hl
    ld hl,6                         ; R.H at +4 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl                        ; HL = L.H, DE = R.H
    cp hl,de
    jp Z,cc_low
    jp C,lr_neg
    jp lr_pos

.cc_low
    ld hl,10
    add hl,sp
    ex de,hl
    ld hl,(de)
    push hl
    ld hl,4                         ; R.L at +2 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl
    sub hl,de
    jp C,lr_neg
    ld a,h
    or l
    ret

.cc_neg
    ld hl,4
    add hl,sp
    ex de,hl
    ld hl,(de)
    push hl
    ld hl,14                        ; L.H at +12 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl                        ; HL = R.H, DE = L.H
    cp hl,de
    jp Z,cc_low_neg
    jp C,lr_neg
    jp lr_pos

.cc_low_neg
    ld hl,2
    add hl,sp
    ex de,hl
    ld hl,(de)
    push hl
    ld hl,12                        ; L.L at +10 +2
    add hl,sp
    ex de,hl
    ld hl,(de)
    pop de
    ex de,hl
    sub hl,de
    jp C,lr_neg
    ld a,h
    or l
    ret

.cc_dsign
    ld a,b
    rla
    jp C,lr_neg
    jp lr_pos


.cp_rz
    ld hl,4
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,lr_eq
    ld hl,5
    add hl,sp
    ld a,(hl)
    rla
    jp NC,lr_pos
    jp lr_neg

.cp_lz
    ld hl,9
    add hl,sp
    ld a,(hl)
    rla
    jp NC,lr_neg
    jp lr_pos

.cc_rz
    ld hl,12
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,lr_eq
    ld hl,13
    add hl,sp
    ld a,(hl)
    rla
    jp NC,lr_pos
    jp lr_neg

.cc_lz
    ld hl,5
    add hl,sp
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
