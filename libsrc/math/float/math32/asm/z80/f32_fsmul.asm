;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul - z80 floating point multiply
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; calculation for the z80 is done by replicating z180 mlt de functionality
; with a fast 16_8x8 multiply, with zero operand and zero bit elimination.
;
; abc * def
;
; = (ab*2^8+c) * (de*2^8+f)
; = ab*de*2^16 +
;   ab*f*2^8 + c*de*2^8 +
;   c*f
;
; = a*d*2^32 + a*e*2^24 + b*d*2^24 + b*e*2^16 + 
;   a*f*2^16 + b*f*2^8 +
;   c*d*2^16 + c*e*2^8 +
;   c*f
;
; = (a*d)*2^32 +
;   (a*e + b*d)*2^24 +
;   (b*e + a*f + c*d)*2^16 +
;   (b*f + c*e)*2^8 +
;   (c*f)*2^0
;
; assume worst overflow case:  abc=def=0xffffff
; assume worst underflow case: abc=def=0x800000
;
;   0xFF FF FF * 0xFF FF FF = 0x FF FF FE 00 00 01
;
;   0x80 00 00 * 0x80 00 00 = 0x 40 00 00 00 00 00
;
;   for underflow, maximum left shift is 1 place
;   so we should report 32 bits of accuracy (don't need all 48 bits)
;   = 24 bits significant + 1 bit shift + 7 bits rounding
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_nzero, m32_fsconst_pzero
EXTERN m32_fsconst_ninf, m32_fsconst_pinf, m32_fsconst_pnan
EXTERN m32_mulu_32h_24x24

PUBLIC m32_fsmul, m32_fsmul_callee


.m32_fsmul
    ex de,hl                    ; DEHL -> HLDE

    ld a,h                      ; put sign bit into A
    add hl,hl                   ; shift exponent into H
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    exx                         ; first h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld hl,002h                  ; get second operand off of the stack
    add hl,sp
    ld e,(hl+)
    ld d,(hl+)
    ld c,(hl+)
    ld h,(hl)
    ld l,c                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    jr fmrejoin


.m32_fsmul_callee
    ex de,hl                    ; DEHL -> HLDE

    ld a,h                      ; put sign bit into A
    add hl,hl                   ; shift exponent into H
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    exx                         ; first h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm

    pop hl                      ; pop return address
    pop de                      ; get second operand off of the stack
    ex (sp),hl                  ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm; ret → stack

.fmrejoin
    xor a,h                     ; xor sign flags
    ex af,af                    ; save sign flag in a[7]' and f' reg

    add hl,hl                   ; shift exponent into h
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

                                ; second h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ; cold: exp 255 / 0×Inf|NaN (push af preserves bias-adj C across e1 gate)
    ld a,h
    inc a
    jp Z,mul_spec2              ; second exp was 255
    ld a,h
    or a                        ; second exponent zero then result is zero
    jp Z,mul_z2

    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    push af                     ; adj second exp + C
    exx
    ld a,h
    inc a
    jr NZ,mul_e1_finite
    pop af
    jp mul_spec1                ; first exp was 255 (second finite nonzero)
.mul_e1_finite
    pop af                      ; a = bias-adj second, C from sub
    ld b,a                      ; bias-adjusted second exp
    jr C,fmchkuf

    add a,h                     ; sum of exponents
    jp C,mulovl                 ; only if h != 0
    cp b                        ; a == b ⇒ first exp was 0
    jp Z,mulzero                ; 0 * finite → signed zero
    jr fmnouf

.fmchkuf
    add a,h                     ; add the exponents
    jp NC,mulzero               ; underflow or first exp == 0 (add 0 never carries)

.fmnouf
    ld b,a
    or a
    jp Z,mulzero                ; check sum of exponents for zero

    ex af,af
    ld a,b
    push af                     ; stack: sum of exponents a, and xor sign of exponents in f

                                ; first  h  = eeeeeeee, lde  = 1mmmmmmm mmmmmmmm mmmmmmmm
                                ; second h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm
                                ; sum of exponents in a', xor of exponents in sign f'
                                ;
                                ; multiplication of two 24-bit numbers into a 32-bit product
    call m32_mulu_32h_24x24     ; exit  : HLDE  = 32-bit product

    pop bc                      ; retrieve sign and exponent from stack = b,c[7]

    bit 7,h                     ; need to shift result left if msb!=1
    jr NZ,fm2
    sla e
    rl d
    adc hl,hl
    jr fm3

.fm2
    inc b
    jp Z,m32_fsconst_pnan       ; capture overflow from NaN
    inc b
    jp Z,mulovl                 ; capture overflow into Inf
    dec b

.fm3
    ld a,e
    ld e,h                      ; put 24 bit mantissa in place, HLD into EHL
    ld h,l
    ld l,d

    ; IEEE RNE: residual A → G=bit7, S=bits6..0 (via add a,a), B=L.0
    add a,a
    jr NC,fm4                   ; G=0 → truncate
    jr NZ,fm_up                 ; G=1 S≠0 → up
    bit 0,l
    jr Z,fm4                    ; tie, already even
.fm_up
    inc l
    jr NZ,fm4
    inc h
    jr NZ,fm4
    inc e
    jr NZ,fm4
    ld hl,0                     ; mant overflow → 1.0, exp++ (E=0; sla e discards implicit 1)
    ld e,l
    inc b
    jr Z,fm_rnovl

.fm4
    sla e                       ; adjust mantissa for exponent
    sla c                       ; put sign into C
    ld d,b                      ; put exponent in D
    rr de                       ; put sign and 7 exp bits into place
                                ; put last exp bit into place
    ret                         ; return IEEE DEHL

.fm_rnovl
    sla c
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf

    ; ---- cold specials ----
    ; mant NaN test after unpack: L[6:0]|D|E (implicit bit in L.7)

.mul_spec2                      ; second exp 255; first in h'
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; second is NaN
    exx
    ld a,h
    or a
    jp Z,m32_fsconst_pnan       ; Inf * 0
    inc a
    jr NZ,mulovl                ; Inf * finite nonzero → signed Inf
    ; Inf * Inf/NaN
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; first is NaN
    jr mulovl                   ; Inf * Inf → signed Inf

.mul_spec1                      ; first exp 255; second finite 1..254; on first bank
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; first is NaN
    jr mulovl                   ; Inf * finite → signed Inf

.mul_z2                         ; second exp 0; first in h'
    exx
    ld a,h
    inc a
    jp Z,m32_fsconst_pnan       ; 0 * Inf/NaN
    ; fall through: 0 * finite or 0 * 0 → signed zero

.mulzero
    ex af,af                    ; get sign
    rla
    jp C,m32_fsconst_nzero
    jp m32_fsconst_pzero        ; done underflow

.mulovl
    ex af,af                    ; get sign
    rla
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf         ; done overflow

