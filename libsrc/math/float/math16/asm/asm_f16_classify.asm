;
;  feilipu, 2020 / 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_classify — classify IEEE binary16 in HL (z80 family + 8085)
;-------------------------------------------------------------------------
;
; Shared portable source (no expand to f24, no exx, no CPU-only ops).
;
; Packed half in HL:
;   H = s e e e e e m m
;   L = m m m m m m m m
;
; Exp field is H[6:2].  Mask 0x7c:
;   0x00 → zero (exp==0; subnormals count as zero)
;   0x7c → inf if mant==0, else NaN
;   else → finite number
;
; Return codes (same as math32 m32_fpclassify):
;   A = 0 number, 1 zero, 2 nan, 3 inf
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f16_classify


.asm_f16_classify
    ; enter : hl = half x
    ; exit  : hl = half x (unchanged)
    ;            a = 0 number, 1 zero, 2 nan, 3 inf
    ; uses  : af

    ld a,h
    and 07ch                    ; exp field H[6:2]
    jr Z,f16class_zero

    cp 07ch                     ; all five exp bits set?
    jr NZ,f16class_number

    ; exp == 31: inf if mantissa bits are 0, else NaN
    ld a,h
    and 003h                    ; H[1:0] mant
    or l
    ld a,3                      ; inf
    ret Z
    dec a                       ; nan (2)
    ret

.f16class_number
    xor a                       ; 0 = number
    ret

.f16class_zero
    ld a,1                      ; 1 = zero
    ret
