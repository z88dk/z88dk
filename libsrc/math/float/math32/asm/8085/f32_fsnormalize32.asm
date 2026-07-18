;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsnormalize32 — expanded 32-bit mantissa normalize
;
; Unpacked: B=exp, C[7]=sign, DEHL=32-bit mant (D=MSB). Same as Z80.
; Left-shift until bit31 set; adjust B. Underflow/zero → zero (B=0, mant=0).
; Sign C preserved except on zero (C left as-is / zero path clears mant+exp).
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize32


.m32_fsnormalize32
    ; C1: already normalized (bit31) or single left shift
    ld a,d
    and 080h
    ret NZ
    ld a,d
    and 040h
    jp Z,norm_tree
    add hl,hl
    rl de
    ld a,-1
    add a,b
    jp NC,normzero
    ld b,a
    ret

;-----------------------------------------------------------------------
; C2 tree: nibble dispatch; shared promote tails.
; After C1, S32H only needs 2 or 3 shifts.
;-----------------------------------------------------------------------
.norm_tree
    ld a,d
    or a
    jp Z,fa8a
    and 0f0h
    jp Z,S32L
    jp S32H

.fa8a
    ld a,e
    or a
    jp Z,fa8b
    and 0f0h
    jp Z,S24L
    jp S24H

.fa8b
    ld a,h
    or a
    jp Z,fa8c
    and 0f0h
    jp Z,S16L
    jp S16H

; Only L nonzero — low-byte residual after cancellation
.fa8c
    ld a,l
    or a
    jp Z,normzero
    push bc
    ld c,0
.s8lp
    ld a,d
    and 080h
    jp NZ,s8done
    add hl,hl
    rl de
    inc c
    ld a,c
    cp 32
    jp C,s8lp
    pop bc
    jp normzero
.s8done
    pop de                          ; D=exp E=sign
    ld a,d
    sub c
    jp C,normzero
    jp Z,normzero
    ld b,a
    ld c,e
    ret

;-----------------------------------------------------------------------
; D high nibble live, bits 7–6 clear → 2 or 3 shifts
.S32H
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    jp C,S32H_u2
    ld a,-3
    jp normdone

.S32H_u2
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-2
    jp normdone

;-----------------------------------------------------------------------
.S32L                           ; 4–7 left shifts
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    ld a,d
    and 0f0h
    jp Z,S32L4more
    add hl,hl
    rl de
    add hl,hl
    rl de
    jp C,S32L_u4
    add hl,hl
    rl de
    jp C,S32L_u5
    ld a,-6
    jp normdone

.S32L4more
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    ld a,-7
    jp normdone

.S32L_u4
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-4
    jp normdone

.S32L_u5
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-5
    ; fall through

.normdone
    add a,b
    jp NC,normzero
    ld b,a
    ret

.normzero
    xor a
    ld b,a
    ld d,a
    ld e,a
    ld h,a
    ld l,a
    ret

; Promote E:H:L → D:E:H:L with L=0; A = shift adjust
.prom_ehl
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    jp normdone

; Promote HL → DE, clear HL; A = shift adjust
.prom_hl
    ex de,hl
    ld hl,0
    jp normdone

;-----------------------------------------------------------------------
.S16L
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,h
    and 0f0h
    jp Z,S16L4more
    add hl,hl
    add hl,hl
    jp C,S16L_u4
    add hl,hl
    jp C,S16L_u5
    ld a,-22
    jp prom_hl

.S16L_u4
    call rr_hl
    ld a,-20
    jp prom_hl

.S16L_u5
    call rr_hl
    ld a,-21
    jp prom_hl

.S16L4more
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,-23
    jp prom_hl

;-----------------------------------------------------------------------
.S24L
    add hl,hl
    ld a,e
    rla
    ld e,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,e
    and 0f0h
    jp Z,S24L4more
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,e
    or a
    jp M,S24L4
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,e
    or a
    jp M,S24L5
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,-14
    jp prom_ehl

.S24L4
    ld a,-12
    jp prom_ehl

.S24L5
    ld a,-13
    jp prom_ehl

.S24L4more
    add hl,hl
    ld a,e
    rla
    ld e,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,-15
    jp prom_ehl

;-----------------------------------------------------------------------
.S24H
    add hl,hl
    ld a,e
    rla
    ld e,a
    jp C,S24H_u0
    ld a,e
    or a
    jp M,S24H1
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,e
    or a
    jp M,S24H2
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,-11
    jp prom_ehl

.S24H_u0
    ld a,e
    rra
    ld e,a
    call rr_hl
    ld a,-8
    jp prom_ehl

.S24H1
    ld a,-9
    jp prom_ehl

.S24H2
    ld a,-10
    jp prom_ehl

;-----------------------------------------------------------------------
.S16H
    add hl,hl
    jp C,S16H_u0
    add hl,hl
    jp C,S16H1
    add hl,hl
    jp C,S16H2
    ld a,-19
    jp prom_hl

.S16H_u0
    call rr_hl
    ld a,-16
    jp prom_hl

.S16H1
    call rr_hl
    ld a,-17
    jp prom_hl

.S16H2
    call rr_hl
    ld a,-18
    jp prom_hl

;-----------------------------------------------------------------------
; Logical right 1 of DEHL through C (8085: no rr de)
.rr_dehl
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
.rr_hl
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ret
