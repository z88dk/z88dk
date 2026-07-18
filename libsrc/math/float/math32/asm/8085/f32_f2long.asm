;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 float → long/int (m32_f2* and sccz80 l_f32_f2*)
; Mirror Z80 f32_f2long. Exp lives in C (8085 shifts via A clobber A).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN l_long_neg
EXTERN l_f32_zero

PUBLIC m32_f2slong, m32_f2ulong, m32_f2sint, m32_f2uint
PUBLIC l_f32_f2slong, l_f32_f2ulong, l_f32_f2sint, l_f32_f2uint


; DEHL = IEEE float → DEHL = integer
.m32_f2sint
.m32_f2uint
.m32_f2slong
.m32_f2ulong
.l_f32_f2sint
.l_f32_f2uint
.l_f32_f2slong
.l_f32_f2ulong
    ld b,d                          ; B = sign | exp[7:1] (for sign later)
    ld a,d
    ld c,a
    ld a,e
    rla                             ; rl e via A
    ld e,a
    ld a,c
    rla                             ; A = full exponent
    or a
    jp Z,l_f32_zero
    cp 07eh+32
    jp NC,l_f32_zero
    ld c,a                          ; C = exp (must survive A-clobbering shifts)

    ; scf; rr e — hidden 1 into E
    scf
    ld a,e
    rra
    ld e,a
    ld d,e
    ld e,h
    ld h,l
    ld l,0                          ; DEHL = mant << 8

.f2_loop
    ; srl d; rr e; rr h; rr l
    or a
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
    inc c
    ld a,c
    cp 07eh+32
    jp NZ,f2_loop

    ld a,b
    rla                             ; sign → CF
    call C,l_long_neg
    ret
