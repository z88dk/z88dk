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
    ld a,d
    or a
    jp Z,fa8a
    and 0f0h
    jp Z,S32L                   ; msb nibble empty → 4–7 shifts
    jp S32H                     ; msb nibble has bits → 0–3 shifts

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

; Only L nonzero (bits 7..0) — Z80 f32_fsnormalize32 omitted this path;
; required when cancellation leaves a low-byte residual.
.fa8c
    ld a,l
    or a
    jp Z,normzero
    push bc                         ; save exp/sign
    ld c,0                          ; shift count
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
    pop de                          ; D=exp E=sign (from push bc)
    ld a,d
    sub c                           ; exp - shifts
    jp C,normzero
    jp Z,normzero
    ld b,a
    ld c,e                          ; restore sign
    ret

;-----------------------------------------------------------------------
.S32H                           ; 0–3 left shifts (bits already in D high nibble)
    add hl,hl
    rl de
    jp C,S32H1
    add hl,hl
    rl de
    jp C,S32H2
    add hl,hl
    rl de
    jp C,S32H3
    ld a,-3
    jp normdone

.S32H1
    call rr_dehl                ; undo overshift
    ret                         ; already normalized

.S32H2
    call rr_dehl
    ld a,-1
    jp normdone

.S32H3
    call rr_dehl
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
    jp C,S32Lover1
    add hl,hl
    rl de
    jp C,S32Lover2
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

.S32Lover1
    call rr_dehl
    ld a,-4
    jp normdone

.S32Lover2
    call rr_dehl
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

;-----------------------------------------------------------------------
; 16-bit significant in HL only (D=E=0 path leads here with bits in H)
.S16L
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,h
    and 0f0h
    jp Z,S16L4more
    add hl,hl
    add hl,hl
    jp C,S16Lover1
    add hl,hl
    jp C,S16Lover2
    ex de,hl
    ld hl,0
    ld a,-22
    jp normdone

.S16Lover1
    call rr_hl
    ex de,hl
    ld hl,0
    ld a,-20
    jp normdone

.S16Lover2
    call rr_hl
    ex de,hl
    ld hl,0
    ld a,-21
    jp normdone

.S16L4more
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ex de,hl
    ld hl,0
    ld a,-23
    jp normdone

;-----------------------------------------------------------------------
; 24-bit in L:E (D was 0); shift into DEHL
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
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-14
    jp normdone

.S24L4
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-12
    jp normdone

.S24L5
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-13
    jp normdone

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
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-15
    jp normdone

;-----------------------------------------------------------------------
.S24H
    add hl,hl
    ld a,e
    rla
    ld e,a
    jp C,S24H1
    ld a,e
    or a
    jp M,S24H2
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,e
    or a
    jp M,S24H3
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-11
    jp normdone

.S24H1
    ld a,e
    rra
    ld e,a
    call rr_hl
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-8
    jp normdone

.S24H2
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-9
    jp normdone

.S24H3
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-10
    jp normdone

;-----------------------------------------------------------------------
.S16H
    add hl,hl
    jp C,S16H1
    add hl,hl
    jp C,S16H2
    add hl,hl
    jp C,S16H3
    ex de,hl
    ld hl,0
    ld a,-19
    jp normdone

.S16H1
    call rr_hl
    ex de,hl
    ld hl,0
    ld a,-16
    jp normdone

.S16H2
    call rr_hl
    ex de,hl
    ld hl,0
    ld a,-17
    jp normdone

.S16H3
    call rr_hl
    ex de,hl
    ld hl,0
    ld a,-18
    jp normdone

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
