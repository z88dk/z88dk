;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fssqr - z80 floating point square
;-------------------------------------------------------------------------
;
; since the z180, and z80-zxn only have support for 8x8bit multiply,
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
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN m32_fszero_fastcall
EXTERN m32_sqr_32h_24x24

PUBLIC m32_fssqr_fastcall


.m32_fssqr_fastcall
    ex de,hl                    ; DEHL -> HLDE

    add hl,hl                   ; shift exponent into H, ignore sign bit
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    ld a,h                      ; calculate the exponent
    or a                        ; exponent zero then result is zero
    jp Z,m32_fszero_fastcall

    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    jr C,fmchkuf

    add a,h
    jp C,mulovl
    jr fmnouf

.fmchkuf
    add a,h                     ; add the exponents
    jp NC,m32_fszero_fastcall

.fmnouf
    or a
    jp Z,m32_fszero_fastcall
    ld b,a
    ex af,af
    ld a,b
    ex af,af                    ; save sum of exponents a'

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

.fm1
    ex af,af                    ; retrieve exponent from af'

    bit 7,h                     ; need to shift result left if msb!=1
    jr NZ,fm3a
    sla e
    rl d
    adc hl,hl
    jr fm3b

.fm3a
    inc a
    jr C,mulovl

.fm3b
    ex af,af
    ld a,e                      ; round using digi norm's method
    or a
    jr Z,fm3c
    set 0,d

.fm3c
    ex af,af

    ld e,h                      ; put 24 bit mantissa in place, HLD into EHL
    ld h,l
    ld l,d

    srl a                       ; adjust the sign (+ve) and exponent
    jr C,fm4
    res 7,e                     ; clear the implicit bit when doesn't match lsb of exp

.fm4
    ld d,a                      ; put sign and 7 msbs into place in D
    ret                         ; return DEHL

.mulovl
    ld d,07fh                  ; set positive INF
    ld e,080h
    ld hl,0
    ret                         ; done overflow

