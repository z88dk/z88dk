;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 m32_f2long — IEEE single to long
;-------------------------------------------------------------------------
;
; CB srl/rr on D,E,H,L. Shift count = (0x7e+32) − exp.

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
    ld b,d                          ; B = sign | exp[7:1]
    ld a,d
    rl e
    rla                             ; A = exponent (rla forces Z=0)
    or a
    jp Z,l_f32_zero
    cp 07eh+32
    jp NC,l_f32_zero

    ld c,a
    ld a,07eh+32
    sub c
    ld c,a                          ; C = shift count (>= 1)

    scf
    rr e                            ; hidden 1
    ld d,e
    ld e,h
    ld h,l
    ld l,0                          ; DEHL = mant << 8

.f2_loop
    srl d
    rr e
    rr h
    rr l
    dec c
    jr NZ,f2_loop

    rl b                            ; sign → CF
    call C,l_long_neg
    ret
