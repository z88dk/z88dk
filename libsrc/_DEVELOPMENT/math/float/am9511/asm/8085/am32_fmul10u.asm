;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------
; asm_am9511_fmul10 - z80, z180, z80n floating point multiply by 10 positive
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_fmul10u_fastcall

.asm_am9511_fmul10u_fastcall
    rl de                       ; get exponent in d

    inc d
    dec d
    jp Z,zero_legal             ; return IEEE zero

    scf                         ; set hidden bit
    ld a,e                      ; return mantissa to ehl
    rra
    ld e,a

                                ; 10*a = 2*(4*a + a)     
    push de                     ; dehl *= 10
    push hl

    xor a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a

    xor a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a

    ex de,hl
    ex (sp),hl
    add hl,de
    pop de
    ex (sp),hl
    ld a,l
    adc a,e
    ld e,a
    pop hl

    ld a,3                      ; exponent increase
    jp NC,no_carry

    ld a,e                      ; shift if a carry
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a

    ld a,4                      ; and increment exponent

.no_carry
    add a,d                     ; resulting exponent
    jp C,infinity

    ld d,a

    ld a,e
    rla
    ld e,a

    xor a                       ; replace +sign and exponent
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a

    ret                         ; return IEEE DEHL

.zero_legal
    ld e,d                      ; use 0
    ld hl,de

    ld a,d
    rra                         ; restore the sign and exponent
    ld d,a

    ret                         ; return IEEE signed ZERO in DEHL

.infinity
    ld de,0
    ld hl,de

    dec d                       ; 0xff

    ld a,d
    rra                         ; restore the sign and exponent
    ld d,a
    ld a,e
    rra                         ; return exponent and mantissa
    ld e,a

    scf
    ret                         ; return IEEE signed INFINITY in DEHL
