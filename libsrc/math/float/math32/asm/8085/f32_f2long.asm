;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 float → long/int (m32_f2* and sccz80 l_f32_f2*)
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
    ld b,d                          ; B = sign | exp[7:1]
    ld a,e
    add a,a                         ; E <<= 1; C = old E.7 = exp bit0
    ld a,d
    rla                             ; A = exponent
    or a
    jp Z,l_f32_zero
    cp 07eh+32
    jp NC,l_f32_zero

    push af                         ; save exp
    ; hidden 1 into E (already left-shifted once)
    scf
    ld a,e
    rra
    ld d,a                          ; D = 1.mant[22:16]
    ld e,h
    ld h,l
    ld l,0
    ld c,0                          ; extension
    pop af                          ; A = exp

.f2_loop
    push af                         ; save exp
    or a                            ; clear C for logical >> 
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
    ld a,c
    rra
    ld c,a
    pop af
    inc a
    cp 07eh+32
    jp NZ,f2_loop

    ; sign from B.7
    ld a,b
    rla
    call C,l_long_neg
    ret
