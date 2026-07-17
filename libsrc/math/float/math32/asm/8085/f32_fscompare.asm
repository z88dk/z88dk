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
; Total order via sign-magnitude → biased int transform.
; IEEE zero if exponent is zero (±0 compare equal).
;
; Exit:
;   Z  = equal (including ±0)
;   NZ = not equal
;   C  = left < right
;   NC = left >= right
;   HL = 1
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_compare, m32_compare_callee


.m32_compare
    ; stack: ret_this, ret_real, left, right
    pop hl
    ld (cmp_rt),hl
    pop hl
    ld (cmp_rr),hl
    pop hl
    pop de
    ld (cmp_ll),hl
    ld (cmp_lh),de
    pop hl
    pop de
    ld (cmp_rl),hl
    ld (cmp_rh),de
    ; restore right, left, rets
    push de
    push hl
    ld de,(cmp_lh)
    ld hl,(cmp_ll)
    push de
    push hl
    ld hl,(cmp_rr)
    push hl
    ld hl,(cmp_rt)
    push hl
    jp cmp_body


.m32_compare_callee
    ; DEHL = right; stack: ret_this, ret_real, left  (left is dropped)
    ld (cmp_rl),hl
    ld (cmp_rh),de
    pop hl
    ld (cmp_rt),hl
    pop hl
    ld (cmp_rr),hl
    pop hl
    pop de
    ld (cmp_ll),hl
    ld (cmp_lh),de
    ; restore rets only
    ld hl,(cmp_rr)
    push hl
    ld hl,(cmp_rt)
    push hl

.cmp_body
    ; right zero? (exp == 0). Note: 8085 rla does NOT update Z.
    ld de,(cmp_rh)
    call exp_zero
    jp Z,right_zero

    ; left zero?
    ld de,(cmp_lh)
    call exp_zero
    jp Z,left_zero_right_nz

    ; both non-zero: transform and subtract left - right
    ld de,(cmp_rh)
    ld hl,(cmp_rl)
    call xform
    ld (cmp_rh),de
    ld (cmp_rl),hl

    ld de,(cmp_lh)
    ld hl,(cmp_ll)
    call xform
    ld (cmp_ll),hl
    ld (cmp_lh),de

    ld hl,(cmp_ll)
    ld de,(cmp_rl)
    ld a,l
    sub e
    ld c,a
    ld a,h
    sbc a,d
    ld b,a
    ld hl,(cmp_lh)
    ld de,(cmp_rh)
    ld a,l
    sbc a,e
    ld l,a
    ld a,h
    sbc a,d
    jp C,ret_neg

    or l
    or b
    or c
    ld hl,1
    ret                             ; Z if equal, NC

.right_zero
    ld de,(cmp_lh)
    call exp_zero
    jp Z,ret_eq
    ; C = sign of left from exp_zero side path — reload sign
    ld a,(cmp_lh+1)
    rla
    jp NC,ret_pos
    jp ret_neg

.left_zero_right_nz
    ld a,(cmp_rh+1)
    rla                             ; C = sign of right
    jp NC,ret_neg
    jp ret_pos

.ret_eq
    ld hl,1
    xor a
    ret

.ret_pos
    ld hl,1
    ld a,1
    or a
    ret

.ret_neg
    ld hl,1
    ld a,1
    or a
    scf
    ret


; Z if exp==0 for float in DE.. (only D and E used)
.exp_zero
    ld a,d
    and 07fh
    ret NZ
    ld a,e
    and 080h
    ret


; DEHL IEEE → total-order uint32 (nonzero exp)

.xform
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a                          ; C = original sign
    ccf
    jp C,xf_pos                     ; original positive
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


SECTION bss_fp_math32
cmp_rt: defs 2
cmp_rr: defs 2
cmp_ll: defs 2
cmp_lh: defs 2
cmp_rl: defs 2
cmp_rh: defs 2
