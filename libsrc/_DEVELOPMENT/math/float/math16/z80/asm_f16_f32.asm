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
;  unpacked format: sign in d[7], exponent in e, mantissa in hl
;  return normalized result also in unpacked format
;
;  return f24 float in hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f24_f32
PUBLIC asm_f32_f24
PUBLIC asm_f24_f16
PUBLIC asm_f16_f24

; convert f32 to f24
.asm_f24_f32
    xor a
    rl e
    rl d                        ; capture exponent in d, sign in carry
    rra                         ; capture sign in a
    scf                         ; set implicit bit
    rr e                        ; mantissa in ehl
    ld l,h                      ; create 16 bit mantissa by truncation
    ld h,e
    ld e,d                      ; save exponent
    ld d,a                      ; save sign
    ret                         ; result in dehl

; convert f24 to f32
.asm_f32_f24
    ld a,d                      ; preserve sign in a
    ld d,e                      ; exponent to d
    ld e,h                      ; mantissa padded to ehl
    ld h,l
    ld l,0
    rl e                        ; remove implicit bit
    rla                         ; sign in carry
    rr d                        ; sign and exponent in d
    rr e                        ; exponent and mantissa in e (hl)
    ret

; convert f16 to f24
.asm_f24_f16
    ld d,h                      ; capture sign in d
    ld e,h                      ; capture exponent in e
    ld h,l                      ; mantissa padded to ehl
    ld l,0
    srl e                       ; shift & position exponent
    rr h
    rr l
    srl e
    rr h
    rr l
    ld a,01Fh                   ; separate exponent
    and e
    add a,(127-15)              ; convert bias to 8 bits
    ld e,a
    scf                         ; set implicit bit
    rr h                        ; align mantissa to hl
    rr l
    ret

; convert f24 to f16
.asm_f16_f24
    ld a,e                      ; exponent to a
    and 07Fh                    ; check for zero
    jp Z,asm_f16_zero           ; return zero
    sub a,(127-15)              ; convert to f24 bias
    jp M,asm_f16_zero           ; zero if number too small
    cp 31
    jp NC,asm_f16_inf           ; infinity if number too large
    
    sla l                       ; position mantissa
    rl h                        ; remove implicit bit
    sla l
    rl h
    rl e                        ; move mantissa into e
    sla l
    rl h
    rl e
    sla e                       ; set e ready for sign
    sla d                       ; move sign to carry
    rr e                        ; place it in e, with exponent and mantissa e (hl)
    ld l,h                      ; position f16 in hl
    ld h,e
    ret
