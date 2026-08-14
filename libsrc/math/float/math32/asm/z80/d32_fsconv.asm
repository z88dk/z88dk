;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2019 April
;  adapted for z80, z180, and z80n
;
;  ped7g, 2026 August
;  optimized for code size and performance
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_float8
PUBLIC m32_float16
PUBLIC m32_float32

PUBLIC m32_float8u
PUBLIC m32_float16u
PUBLIC m32_float32u

EXTERN m32_fsnormalize

; convert signed char in l to float in dehl
.m32_float8
    ld a,l
    rla                         ; sign bit of a into C
    sbc a,a
    ld h,a                      ; now hl is sign extended, piggyback m32_float16 entry

; convert integer in hl to float in dehl
.m32_float16
    ld b,h                      ; sign bit to B
    xor a                       ; clear carry for `ex af,af` later and use value 0
    ld e,a                      ; e = 0
    bit 7,b
    jr z,f24normalize           ; sign is +, ehl is extended to uint24
    ld a,h                      ; sign is -, negate hl (sign stays in B), ehl becomes uint24
    cpl
    ld h,a
    ld a,l
    cpl
    ld l,a
    inc hl                      ; hl = ~hl+1 is faster than hl = 0-hl and keeps e=0 and carry=0
.f24normalize
    ld c,150
    ex af,af                    ; clear carry in F'
    ex de,hl
    jp m32_fsnormalize          ; exponent in c, sign in b[7], mantissa in lde

; convert long in dehl to float in dehl
.m32_float32
    ld b,d                      ; to hold the sign, copy top byte to b
    bit 7,b
    jr z,dldf1                  ; number in dehl, sign in b[7]
    ex de,hl                    ; hlde is negative int32, negate it
    ld c,l                      ; bc = copy of hl (MSW)
    xor a                       ; clear CF and a
    ld h,a
    ld l,a
    sbc hl,de                   ; negate LSW part
    ex de,hl
    ld h,a
    ld l,a
    sbc hl,bc                   ; negate MSW part
    ex de,hl
    jp po,dldf1                 ; number in dehl, sign in b[7]
; here negation of 0x80000000 = -2^31 = 0xcf000000
    ld de,0cf00h
    ld hl,0
    ret

; convert character in l to float in dehl
.m32_float8u
    ld h,0

; convert unsigned in hl to float in dehl
.m32_float16u
    ld de,0

; convert unsigned long in dehl to float in dehl
.m32_float32u
    res 7,b                     ; ensure unsigned long's "sign" bit is reset
                                ; to hold the sign, put copy of MSB into b
                                ; continue, with unsigned long number in dehl

.dldf1
; number in dehl, sign in b[7]
    ld a,d
    or a
    jr z,f24normalize           ; DEHL < 2**24, use m32_fsnormalize (A = 00)
; must shift right until d = 0 and mantissa is 24b in lde
    ld d,158                    ; exponent (reused by two out of three code paths)
    jp m,dldfshift8             ; SF from `or a` of leading byte, shift by 8 needed (A = 80..FF)
    cp 8                        ; bias left shifts over right shifts (faster shift and smaller code)
    jr c,dldf3                  ; shift right 1 to 3 times (A = 01..07)
; shift right 4 to 7 times by shifting AEHL left 1 to 4 times (A = 08..7F)
.dldfleft
    dec d                       ; lower exp
    add hl,hl
    rl e
    adc a,a                     ; shift left and test top bit for leading 1
    jp p,dldfleft               ; shift until implicit 1 is top (max 4x)
.dldfshift8
    ; AEHL leads by 1, shift right by 8 into EHL and pack it as IEEE float into DEHL
    ld l,h
    ld h,e
    add a,a                     ; discard implicit 1
    rl b                        ; sign bit
    rr d                        ; to exp
    rra                         ; to mant, also clears carry
    ld e,a                      ; result in DEHL
    ret

; here shift AEHL right 1-3 times, A = 01..07
.dldf3
    ld d,151                    ; exponent init value when shifting right
    sra a                       ; `sra a` instead of `rra` to detect implicit 1 by ZF
    jr z,dldfpack               ; total shift right 1x (A was 01)
    inc d
    rr e
    rr hl
    sra a
    jr z,dldfpack               ; total shift right 2x (A was 02..03)
    ; total shift right 3x (A was 04..07)
    inc d
    rr e
    rr hl
.dldfpack
    ; implicit 1 discarded (it's in carry or A==1)
    rl b                        ; get sign
    rr de                       ; sign|exp|mant upper 16b
    rr hl                       ; final shift of mantissa, lower 16b
    or a                        ; result in dehl, clear carry
    ret
