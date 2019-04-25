;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

SECTION code_clib
SECTION code_math

PUBLIC md32_Hi_Bf
PUBLIC md32_Bl_Bf
PUBLIC md32_Hc_Bf
PUBLIC md32_Hu_Bf
PUBLIC md32_Bg_Bf

EXTERN md32_normalize

; convert integer in hl to float in bcde
.md32_Hi_Bf
    ex de,hl                    ; least to de
    ld a,d                      ; sign
    rla                         ; get sign to c
    sbc hl,hl                   ; sign extension, all 1's if neg
    ld b,h
    ld c,l

; now convert long in bcde to float in bcde
.md32_Bl_Bf
    bit 7,b                     ; test sign, neg if neg
    jr Z,blbf2
    ld hl,0
    or a                        ; clear C
    sbc hl,de                   ; least
    ex de,hl
    ld hl,0
    sbc hl,bc
    jp PO,blbf1                 ;   jp novf,.blbf1
;---
; here negation of 0x80000000 = -2^31 = 0xcf000000
    ld bc,0cf00h
    ld de,0
    ret
;
; other entries
.md32_Bg_Bf                     ; convert unsigned long in bcde to float in bcde
    ld h,b                      ; put working copy of unsigned MSB into h
    res 7,b                     ; ensure unsigned long's "sign" bit is reset
    jr bgbf0                    ; continue, with unsigned long number in hcde

.md32_Hc_Bf                     ; convert character in l to float in bcde
    ld h,0
.md32_Hu_Bf                     ; convert unsigned in hl to float in bcde
    ex de,hl
    ld bc,0
.blbf2
    ld h,b
.bgbf0
    ld l,c
.blbf1
; number in hlde
    ld c,150                    ; exponent if no shift
    ld a,h
    or a
    jr NZ,blbfright             ; go shift right
; exponent in c, sign in b
    ex af,af                    ; set carry off
    jp md32_normalize           ; piggy back on existing code
; must shift right
.blbfright
    jp PO,blbf4                 ; shift right  1-4
;---
; here shift right 4-8
    srl h
    rr l
    rr d
    rr e
    srl h
    rr l
    rr d
    rr e
    srl h
    rr l
    rr d
    rr e
    srl h
    rr l
    rr d
    rr e                        ; 4 for sure
    ld c,154                    ; exponent for no more shifts
; here shift right 1-4 more
.blbf4
    ld a,h
    or a
    jr Z,blbf8                  ; done right
    srl h
    rr l
    rr d
    rr e
    inc c
    ld a,h
    or a
    jr Z,blbf8
    srl h
    rr l
    rr d
    rr e
    inc c
    ld a,h
    or a
    jr Z,blbf8
    srl h
    rr l
    rr d
    rr e
    inc c
    ld a,h
    or a
    jr Z,blbf8
    srl h
    rr l
    rr d
    rr e
    inc c
.blbf8
    add hl,hl
    ld a,c
    rl b                        ; get sign (if unsigned long input, was forced 0)
    rra
    rr l
    ld b,a
    ld c,l                      ; result in bcde
    ret                         ; lret

