;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, May 2020 / 2026 July (8085)
;
;-------------------------------------------------------------------------
;  asm_f16_f32 - 8085 unpacked format conversion code
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return f32 and f24 float in dehl, and f16 in hl
;
;  Hot: asm_f24_f16 (expand), asm_f16_f24 (pack). 16-bit shifts via add hl,hl.
;
;  uses: af, bc, de, hl  (expand: af, de, hl only)
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_zero
EXTERN asm_f16_inf
EXTERN asm_f24_zero

PUBLIC asm_f24_f32
PUBLIC asm_f32_f24
PUBLIC asm_f24_f16
PUBLIC asm_f16_f24

PUBLIC asm_f16_f32
PUBLIC asm_f32_f16

; convert f32 to f24
.asm_f24_f32
    ld a,l                      ; capture LSB
    ; sla e: open-code (no sla e on 8085)
    ld b,a
    ld a,e
    add a,a                     ; sla e, C = old e[7]
    ld e,a
    ld a,d
    rla                         ; rl d through C
    ld d,a
    ld a,b
    rra                         ; capture sign in a[7]
    scf                         ; set implicit bit
    ; rr e through C
    ld b,a
    ld a,e
    rra
    ld e,a
    ld a,b
    ld l,h                      ; create 16 bit mantissa by truncation
    ld h,e
    ld e,a                      ; save sign in e[7]
    and a,070h                  ; check for 3 lost bits rounding
    ret Z                       ; result in dehl
    ld a,l
    or 001h
    ld l,a
    ret

; convert f16 to f32
.asm_f32_f16
    call asm_f24_f16

; convert f24 to f32
.asm_f32_f24
    ld a,e                      ; preserve sign in a
    ld e,h                      ; mantissa padded to ehl
    ld h,l
    ld l,0
    ; sla e
    ld b,a
    ld a,e
    add a,a
    ld e,a
    ld a,b
    rla                         ; sign in carry
    ; rr de through C: C→D7, D0→C→E7, E0→C
    ld b,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

; convert f24 to f16
.asm_f16_f24
    ld a,l                      ; rounding using 3 lost bits
    and 00eh
    ld a,l
    jr Z,rounded
    add a,010h                  ; if there were rounding bits
    jr NC,rounded
    inc h
    jr NZ,rounded
    ; mant overflow: C still set from add a,010h; h == 0
    ld b,a                      ; save rounded lsb
    xor a
    rra                         ; a = 0x80 (C→bit7), C=0
    ld h,a
    ld a,b
    rra                         ; continue shift into lsb
    inc d

.rounded
    ld l,a                      ; mantissa lsb to l

    ld a,d                      ; exponent to a
    sub a,127-15                ; convert from f24 bias to half exp
    jp M,asm_f16_zero           ; zero if number too small
    cp 31
    jp NC,asm_f16_inf           ; infinity if number too large

    ; position mantissa: sla l; rl h ×3 ≡ add hl,hl ×3 (C ← old H7)
    ld b,a                      ; half exp
    add hl,hl
    add hl,hl
    ld a,b
    rla                         ; mix C into exp field
    ld b,a
    add hl,hl
    ld a,b
    rla
    rla                         ; room for sign at bit7
    ld b,a
    ld a,e
    add a,a                     ; sign → C
    ld a,b
    rra                         ; place sign with exp+mant
    ld l,h
    ld h,a
    ret

; convert f32 to f16
.asm_f16_f32
    call asm_f24_f32

; convert f16 to f24
.asm_f24_f16
    ld e,h                      ; capture sign in e[7]
    ld a,h
    and 07ch                    ; exp field H[6:2]
    jp Z,asm_f24_zero
    rrca
    rrca                        ; exp in A[4:0]
    add a,127-15
    ld d,a
    ld a,h
    and 003h                    ; top 2 mant bits
    ld h,a                      ; HL = 10-bit mant
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl                   ; <<5 → bits 14..5
    ld a,h
    or 080h                     ; implicit 1
    ld h,a
    ret
