;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fssqr - z80, z180, z80n floating point square
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; calculation for the z80 is done by replicating z180 mlt de functionality
; with a fast 16_8x8 multiply, with zero operand and zero bit elimination.
;
; abc * abc
;
; = (a*a)*2^32 +
;   (2*a*b)*2^24 +
;   (b*b + 2*a*c)*2^16 +
;   (2*b*c)*2^8 +
;   (c*c)*2^0
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

EXTERN m32_fsconst_pzero, m32_fsconst_pinf, m32_fsconst_pnan
EXTERN m32_sqr_32h_24x24

PUBLIC m32_fssqr, m32_fssqr_fastcall
PUBLIC _m32_sqrf

.m32_fssqr
    pop af                      ; ret
    pop hl                      ; y off stack
    pop de
    push de
    push hl
    push af                     ; ret

._m32_sqrf
.m32_fssqr_fastcall
    ex de,hl                    ; DEHL -> HLDE

    add hl,hl                   ; shift exponent into H, ignore sign bit
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    ld a,h                      ; calculate the exponent
    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    jr C,fschkuf

    add a,h
    jp C,m32_fsconst_pinf
    jr fsnouf

.fschkuf
    add a,h                     ; add the exponents
    jp NC,m32_fsconst_pzero

.fsnouf
    or a
    jp Z,m32_fsconst_pzero

    push af                     ; stack: sum of exponents a

                                ; square of two 24-bit numbers into a 32-bit product
                                ;
                                ; result is properly calculated into highest 32-bit result
                                ; from a 48-bit calculation.
                                ;
                                ; Lower 8 bits intended to provide rounding information for
                                ; IEEE floating point mantissa calculations.
                                ;
                                ; enter : abc = lde  = 24-bit multiplier  = x
                                ;

    call m32_sqr_32h_24x24      ; exit  : HLDE  = 32-bit product

    pop bc                      ; retrieve exponent from stack

    bit 7,h                     ; need to shift result left if msb!=1
    jr NZ,fs1
    sla e
    rl d
    adc hl,hl
    jr fs2

.fs1
    inc b
    jp Z,m32_fsconst_pnan       ; capture overflow from NaN
    inc b
    jp Z,m32_fsconst_pinf       ; capture overflow into Inf
    dec b

.fs2
    ld a,e
    ld e,h                      ; put 24 bit mantissa in place, HLD into EHL
    ld h,l
    ld l,d

    ; IEEE RNE: residual A → G=bit7, S=bits6..0, B=L.0
    ld d,a
    and 080h
    jr Z,fs3
    ld a,d
    and 07fh
    jr NZ,fs_up
    bit 0,l
    jr Z,fs3
.fs_up
    inc l
    jr NZ,fs3
    inc h
    jr NZ,fs3
    inc e
    jr NZ,fs3
    ld e,080h
    ld hl,0
    inc b
    jp Z,m32_fsconst_pinf

.fs3
    sla e                       ; adjust mantissa for exponent
    xor a                       ; set sign in C positive
    ld d,b                      ; put exponent in D
    rr de                       ; put sign and 7 exp bits into place
                                ; put last exp bit into place
    ret                         ; return IEEE DEHL

