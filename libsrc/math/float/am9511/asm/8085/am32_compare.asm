;
;  Copyright (c) 2022-2026 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022 / July 2026
;
;-------------------------------------------------------------------------
; asm_am9511_compare_sccz80 - 8085 IEEE float compare
;-------------------------------------------------------------------------
; Same ordering strategy as math32 8085 winner:
;   sign/magnitude + high-word first early-out.
; IEEE float; exp 0 ⇒ ±0. Does not mutate stack args.
;
; Entry (after call): SP = ret1, ret2, right.L, right.H, left.L, left.H
;   (l_f32_* Intel path: push right, then call — two rets above args)
;
; Exit: Z=equal NZ=unequal; C=left<right NC=left>=right; HL=1
; Uses: af, bc, de, hl
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_am9511_compare_sccz80


.asm_am9511_compare_sccz80
    ; right exp 0? high word at sp+6
    ld de,sp+6
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,zero_right

    ; left exp 0? high word at sp+10
    ld de,sp+10
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,zero_left

    ; both non-zero — sign bytes D at sp+7 (right), sp+11 (left)
    ld de,sp+11
    ld a,(de)                           ; left D
    ld b,a
    ld de,sp+7
    ld a,(de)                           ; right D
    ld c,a
    xor b
    and 080h
    jp NZ,diff_sign

    ld a,b
    rla
    jp C,both_neg

    ; both positive: high-word first left.H - right.H
    ld de,sp+10
    ld hl,(de)                          ; left.H
    ld de,sp+6
    ld a,l
    ld b,h
    ld hl,(de)                          ; right.H
    sub l
    ld c,a
    ld a,b
    sbc a,h
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ; lows: left.L - right.L
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
    ld b,a
    jp C,return_negative
    or c                                ; Z if equal; OR → NC
    ld hl,1
    ret

.both_neg
    ; both negative: reverse mag — right.H - left.H first
    ld de,sp+6
    ld hl,(de)                          ; right.H
    ld de,sp+10
    ld a,l
    ld b,h
    ld hl,(de)                          ; left.H
    sub l
    ld c,a
    ld a,b
    sbc a,h
    jp NZ,hi_fin
    or c
    jp NZ,hi_fin
    ld de,sp+4
    ld hl,(de)                          ; right.L
    ld de,sp+8
    ld a,l
    ld b,h
    ld hl,(de)                          ; left.L
    sub l
    ld c,a
    ld a,b
    sbc a,h
    ld b,a
    jp C,return_negative
    or c
    ld hl,1
    ret

.diff_sign
    ; different signs, both non-zero: negative < positive
    ld a,b                              ; left D
    rla
    jp C,return_negative                ; left neg → left < right
    jp return_positive


; A = high byte of high-word diff; C flag from sbc; C reg = low byte of high diff
.hi_fin
    jp C,return_negative
    or c                                ; NZ; OR clears C → NC
    ld hl,1
    ret


.zero_right
    ; right exp 0 — check left high at sp+10
    ld de,sp+10
    ld hl,(de)
    ex de,hl
    call exp_zero
    jp Z,return_equal
    ; left non-zero: sign from left D at sp+11
    ld de,sp+11
    ld a,(de)
    rla
    jp NC,return_positive               ; left + → left > 0
    jp return_negative                  ; left - → left < 0


.zero_left
    ; left exp 0, right non-zero: sign of right D at sp+7
    ld de,sp+7
    ld a,(de)
    rla
    jp NC,return_negative               ; right + → 0 < right
    jp return_positive                  ; right - → 0 > right


.return_equal
    xor a                               ; Z, NC
    ld hl,1
    ret

.return_positive
    ld hl,1
    ld a,1
    or a                                ; NZ, NC
    ret

.return_negative
    ld hl,1
    ld a,1
    or a                                ; NZ
    scf
    ret


; DE = high word (E=low byte of word, D=high); Z if IEEE exponent is zero
.exp_zero
    ld a,d
    and 07fh
    ret NZ
    ld a,e
    and 080h
    ret
