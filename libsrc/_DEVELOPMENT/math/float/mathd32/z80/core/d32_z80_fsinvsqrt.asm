;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;;
;-------------------------------------------------------------------------
; F_invsqrt - floating point inverse square root
;-------------------------------------------------------------------------
;
; Searching for 1/x being the inverse square root of y.
;
; x = 1/y^0.5 where 1/y^.5 can be calculated by:
;
; w[i+1] = w[i]*1.5 - w[i]*w[i]*y/2  where w[0] is approx 1/y^2
;
;   float InvSqrt(float x)
;   {
;       float xhalf = 0.5f*x;
;       int i = *(int*)&x;
;       i = 0x5f375a86 - (i>>1);
;       x = *(float*)&i;
;       x = x*(1.5f-xhalf*x*x);
;       return x;
;   }
;
; The initial magic number lookup gets us 8 bits of precision.
; The next iterations 14, and 26.
; At this point the number is rounded then multiplied by y using F_mul.
;
; Do the work in fixed point with 1 place to left of decimal point.
; 1.7 1.15 1.23 and 1.31, as we move through the calculations.
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN md32_fsmax, m32_mulu_32_16x16, m32_mulu_32h_32x32

EXTERN asm_phexwd, asm_phex, asm_pchar, CHAR_CR

PUBLIC md32_fsinvsqrt

.md32_fsinvsqrt                 ; DEHL
    
    ld a,d
    or a                        ; divide by zero?
    jp Z,md32_fsmax    
    and 080h                    ; negative number?
    jp NZ,md32_fsmax
    
    ld b,d                     ; save original y exponent & mantissa msb
    ld c,e
    
    sla e
    rl d
    scf                         ; restore implicit bit
    rr e                        ; d = eeeeeeee, ehl = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld d,e                      ; mantissa of y in dehl
    ld e,h
    ld h,l
    ld l,0                      ; dehl = 1mmmmmmm mmmmmmmm mmmmmmmm --------

    push de                     ; y msw on stack for w[1]
    push hl                     ; y lsw on stack for w[1]

    ld l,h                      ; original y in bceh
    ld h,e
    ex de,hl                    ; original y in bcde

                                ; now calculate w[0]
    srl b                       
    rr c                        ; y>>1
    rr d
    rr e

    xor a                       ; w[0] = 0x5f375a86 - (y>>1)
    ld hl,05a86h
    sbc hl,de
    ex de,hl
    ld hl,05f37h
    sbc hl,bc                   ; (float) w[0] in hlde

                                ; calculate w[1] in hlde - 26 bits
    sla l
    rl h
    scf                         ; restore implicit bit on w[0]
    rr l                        ; h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld a,h                      ; exponent of w[0] in a = eeeeeeee
    ld h,l                      ; mantissa of w[0] in hlde
    ld l,d
    ld d,e
    ld e,0                      ; a = eeeeeeee hlde = 1mmmmmmm mmmmmmmm mmmmmmmm --------

    ex af,af
    pop af                      ; y lsw in af'
    ex af,af

    pop bc                      ; y msw in bc
    push af                     ; w[0] exponent on stack
    push hl                     ; w[0] msw on stack
    push de                     ; w[0] lsw on stack
    push bc                     ; y msw on stack

    ex af,af
    push af                     ; y lsw on stack
    ex af,af
    
    ex de,hl                    ; w[0] msw in de, w[0] lsw in hl

    push de
    push hl
    exx
    pop hl
    pop de
    exx

    call m32_mulu_32h_32x32     ; dehl*dehl' => dehl, w[0]^2 in dehl, 1.n * 1.n => 2.n

    exx
    pop hl                      ; y lsw in hl'
    pop de                      ; y msw in de'
    exx

    call m32_mulu_32h_32x32     ; dehl*dehl' => dehl, w[0]^2*y in dehl, 2.n * 0.n => 2.n

    ex de,hl                    ; w[0]^2*y/2 in hlde

    ld b,h                      ; w[0]^2*y/2 in bcde
    ld c,l

    xor a
    ld hl,0                     ; ld hl,0
    sbc hl,de
    ex de,hl
    
    ld hl,060h                  ; 1.5 2.n
    sbc hl,bc
    ex de,hl                    ; 1.5 - w[1]^2*y/2 in dehl, 2.n - 2.n

    exx
    pop hl                      ; w[0] lsw in hl'
    pop de                      ; w[0] msw in de'
    exx

    call m32_mulu_32h_32x32     ; dehl*dehl' => dehl, w[0]^2*y in dehl 2.n * 1.n => 3.n

    pop af                      ; recover w[0] exponent
    inc a                       ; adjust for 3.n => 2.n

    bit 7,d                     ; normalise mantissa
    jr NZ,fis0
    dec a
    add hl,hl
    rl e
    rl d
    bit 7,d
    jr NZ,fis0
    dec a
    add hl,hl
    rl e
    rl d
    bit 7,d
    jr NZ,fis0
    dec a
    add hl,hl
    rl e
    rl d
    bit 7,d
    jr NZ,fis0
    dec a
    add hl,hl
    rl e
    rl d

.fis0

    ld b,l
    ld l,h                      ; pack 1/y^0.5 result from a-deh into dehl
    ld h,e
    ld e,d
    sla e
    srl a
    rr e
    ld d,a

    ld a,b                      ; round number using digi norm's method
    or a
    jr Z,fis1
    set 0,l
.fis1

    ret                         ; return DEHL

