;
;  feilipu, 2026 July / August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fpclassify — classify IEEE single in DEHL (z80 family + 8085)
;-------------------------------------------------------------------------
;
; Shared portable source (no exx, no IX, no 8085-only ops).
;
; IEEE DEHL layout:
;   D = s e e e e e e e
;   E = e m m m m m m m
;   H,L = remaining mantissa
;
; Full exponent is assembled without rotating DE:
;   exp = ((D & 0x7f) << 1) | (E >> 7)
;
; Return codes:
;   A = 0  finite number (exp in 1..254)
;   A = 1  zero          (exp == 0; denormals count as zero)
;   A = 2  NaN           (exp == 255, mantissa != 0)
;   A = 3  inf           (exp == 255, mantissa == 0)
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fpclassify


.m32_fpclassify
    ; enter : dehl = float x
    ; exit  : dehl = float x (unchanged)
    ;            a = 0 number, 1 zero, 2 nan, 3 inf
    ; uses  : af
    ;
    ; exp = (D << 1) | (E >> 7) with sign shifted out of D.
    ; Must not AND between capturing E.7 into C and the rla — AND clears C
    ; and would turn exp 255 into 254 (inf/NaN misclassified as finite).

    ld a,e
    add a,a                     ; C = E.7 (exp bit 0); DEHL unchanged
    ld a,d
    rla                         ; A = full 8-bit exponent (sign out to C)

    or a
    jr Z,fpclass_zero           ; exp == 0 → ±0 (math32 denorm policy)

    cpl
    or a
    jr NZ,fpclass_number        ; exp != 255 → finite number

    ; exp == 255: inf if mantissa is 0, else NaN
    ; mantissa bits: E[6:0], H, L  (E.7 was the exp LSB, already not mant)
    ld a,e
    and 07fh
    or h
    or l
    ld a,3                      ; inf
    ret Z
    dec a                       ; nan (2)
    ret

.fpclass_number
    xor a                       ; 0 = number
    ret

.fpclass_zero
    inc a                       ; 1 = zero (A was 0)
    ret
