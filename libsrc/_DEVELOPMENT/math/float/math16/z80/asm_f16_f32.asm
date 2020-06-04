;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, May 2020
;
;-------------------------------------------------------------------------
;  asm_f16_f32 - z80, z180, z80n unpacked format conversion code
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;  return f32 and f24 float in dehl, and f16 in hl
;
;  uses: af, de, hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_zero
EXTERN asm_f16_inf

PUBLIC asm_f24_f32
PUBLIC asm_f32_f24
PUBLIC asm_f24_f16
PUBLIC asm_f16_f24

; convert f32 to f24
.asm_f24_f32
    sla e                       ; capture exponent in d, sign in carry
    rl d
    rra                         ; capture sign in a
    scf                         ; set implicit bit
    rr e                        ; mantissa in ehl
    ld l,h                      ; create 16 bit mantissa by truncation
    ld h,e
    ld e,a                      ; save sign in e[7]
    ret                         ; result in dehl

; convert f24 to f32
.asm_f32_f24
    ld a,e                      ; preserve sign in a
    ld e,h                      ; mantissa padded to ehl
    ld h,l
    ld l,0
    rl e                        ; remove implicit bit
    rla                         ; sign in carry
    rr d                        ; sign and exponent in d
    rr e                        ; exponent and mantissa in e (hl)
    ret

; convert f24 to f16
.asm_f16_f24
    ld a,d                      ; exponent to a
    sub a,127-15                ; convert to f24 bias
    jp M,asm_f16_zero           ; zero if number too small
    cp 31
    jp NC,asm_f16_inf           ; infinity if number too large
    sla l                       ; position mantissa
    rl h                        ; remove implicit bit
    sla l
    rl h
    rla                         ; move mantissa into a
    sla l
    rl h
    rla
    rla                         ; set a ready for sign
    sla e                       ; move sign to carry
    rra                         ; place it in a, with exponent and mantissa
    ld l,h                      ; position f16 in hl
    ld h,a
    ret

; convert f16 to f24
.asm_f24_f16
    ld e,h                      ; capture sign in e[7]
    ld a,h                      ; capture exponent in a
    ld h,l                      ; mantissa padded to ehl
    ld l,0
    rra                         ; shift & position exponent
    rr h
    rr l
    rra
    rr h
    rr l
    and 01Fh                    ; separate exponent
    add a,127-15                ; convert bias to 8 bits
    ld d,a
    scf                         ; set implicit bit
    rr h                        ; align mantissa to hl
    rr l
    ret

