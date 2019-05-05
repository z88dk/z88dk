;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2019 April
;  adapted for z80, z180, and z80-zxn
;
;-------------------------------------------------------------------------
; md32_fsadd - Rabbit floating point add
; md32_fssub - Rabbit floating point subtract
;-------------------------------------------------------------------------
; 1) first section: unpack from F_add: to sort:
;    one unpacked number in hldebc the other in hl'de'bc'
;    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
;         in addition af' holds  b xor b' used to test if add or sub needed
;
; 2) second section: sort from sort to align, sets up smaller number in hldebc and larger in hl'de'bc'
;    This section sorts out the special cases:
;       to alignzero - if no alignment (right) shift needed
;           alignzero has properties: up to 23 normalize shifts needed if signs differ
;                                     not know which mantissa is larger for different signs until sub performed
;                                     no alignment shifts needed
;       to alignone  - if one alignment shift needed
;           alignone has properties: up to 23 normalize shifts needed if signs differ
;                                    mantissa aligned is always smaller than other mantissa
;                                    one alignment shift needed
;       to align     - 2 to 23 alignment shifts needed
;           numbers aligned 2-23 have properties: max of 1 normalize shift needed
;                                                 mantissa aligned always smaller
;                                                 2-23 alignment shifts needed
;       number too small to add, return larger number (to doadd1)
;
; 3) third section alignment - aligns smaller number mantissa with larger mantissa
;    This section does the right shift. Lost bits shifted off, are tested. Up to 8 lost bits
;    are used for the test. If any are non-zero a one is or'ed into remaining mantissa bit 0.
;      align 2-23 - worst case right shift by 7 with lost bits
; 4) 4th section add or subtract
;
; 5) 5th section post normalize
;
; 6) 6th section pack up
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC md32_fssub, md32_fssub_callee
PUBLIC md32_fsadd, md32_fsadd_callee
PUBLIC md32_fsnormalize


; enter here for floating subtract, x-y x on stack, y in dehl
.md32_fssub
    ld a,d                      ; toggle the sign bit for subtraction
    xor 080h
    ld d,a


; enter here for floating add, x+y, x on stack, y in bcde, result in bcde
.md32_fsadd
    ex de,hl                    ; DEHL -> HLDE
    ld b,h                      ; place op1.s in b[7]

    add hl,hl                   ; unpack op1
    ld c,h                      ; save op1.e in c

    ld a,h
    or a
    jr Z,faunp1                 ; add implicit bit if op1.e!=0
    scf

.faunp1
    rr l                        ; rotate in op1.m's implicit bit
    ld a,b                      ; place op1.s in a[7]

    exx

    ld hl,002h                  ; get second operand off of the stack
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld h,(hl)
    ld l,c                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    jp farejoin


; enter here for floating subtract callee, x-y x on stack, y in dehl
.md32_fssub_callee
    ld a,d                      ; toggle the sign bit for subtraction
    xor 080h
    ld d,a


; enter here for floating add callee, x+y, x on stack, y in bcde, result in bcde
.md32_fsadd_callee
    ex de,hl                    ; DEHL -> HLDE
    ld b,h                      ; place op1.s in b[7]

    add hl,hl                   ; unpack op1
    ld c,h                      ; save op1.e in c

    ld a,h
    or a
    jr Z,faunp1_callee          ; add implicit bit if op1.e!=0
    scf

.faunp1_callee
    rr l                        ; rotate in op1.m's implicit bit
    ld a,b                      ; place op1.s in a[7]

    exx

    pop bc                      ; pop return address
    pop de                      ; get second operand off of the stack
    pop hl                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    push bc                     ; return address on stack

.farejoin
    ld b,h                      ; save op2.s in b[7]

    add hl,hl                   ; unpack op2
    ld c,h                      ; save op2.e in c

    xor b                       ; check if op1.s==op2.s
    ex af,af                    ; save results sign in f' (C clear in af')

    ld a,h
    or a
    jr Z,faunp2                 ; add implicit bit if op2.e!=0
    scf

.faunp2
    rr l                        ; rotate in op2.m's implicit bit
    xor a
    ld h,a                      ; op2 mantissa: h = 00000000, lde = 1mmmmmmm mmmmmmmm mmmmmmmm
    exx
    ld h,a                      ; op1 mantissa: h = 00000000, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

; sort larger from smaller and compute exponent difference
.sort
    ld a,c
    exx
    cp a,c                      ; nc if a>=c
    jp Z,alignzero              ; no alignment mantissas equal
    jr NC,sort2                 ; if a larger than c
    ld a,c
    exx
.sort2
    sub a,c                     ; positive difference in a
    cp  a,1                     ; if one difference, special case
    jp Z,alignone               ; smaller mantissa on top

    cp a,24                     ; check for too many shifts
    jr C,align                  ; if 23 or fewer shifts
; use other side, adding small quantity that can be ignored
    exx
    jp doadd1                  ; pack result

; align begin align count zero
.align
    or a
    rra
    jr NC,al_2
    srl h
    rr l
    rr d
    rr e
.al_2
    rra                         ; 1st lost bit to a
    jr NC,al_3
    srl h
    rr l
    rr d
    rr e
    rr h
    rr l
    rr d
    rr e
.al_3
    rra                         ; 2nd lost bit to a
    jr NC,al_4
    srl h
    rr l
    rr d
    rr e
    rr h
    rr l
    rr d
    rr e
    rr h
    rr l
    rr d
    rr e
    rr h
    rr l
    rr d
    rr e
; check for 8 bit right shift
.al_4
    rra                         ;  3rd lost bit to a check shift by 8,
    jr NC,al_5
; shift by 8 right, no 16 possible
    ld a,e                      ; lost bits, keep only 8
    ld e,d
    ld d,l
    ld hl,0                     ; upper zero
    or a                        ; test lost bits
    jr Z,aldone
    set 0,e                     ; lost bits
    jr aldone

; here possible 16
.al_5 
    rra                         ; shift in a zero, lost bits in 6,5,4
    jr NC,al_6                  ; no shift by 16
; here shift by 16
; toss lost bits in a which are remote for 16 shift
; consider only lost bits in d and h
    ld e,l
    ld a,d                        ; lost bits
    ld d,0
    or a,h
    ld h,d                      ; hl zero
    ld l,d
    jr Z,aldone
    set 0,e                     ; lost bits
    jr aldone

; here no 8 or 16 shift, lost bits in a-reg bits 6,5,4, other bits zero's
.al_6
    or a,h                      ; more lost bits
    ld h,0
    jr Z,aldone
    set 0,e
; aldone here
.aldone
    ex af,af                    ; carry clear
    jp P,doadd
; here for subtract, smaller shifted right at least 2, so no more than
; one step of normalize
    push hl
    exx
    ex de,hl
    ex (sp),hl
    ex de,hl
    exx
    pop hl                      ; subtract the mantissas
    sbc hl,de
    exx
    sbc hl,de
    push de
    exx
    ex (sp),hl
    exx
    pop de
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
    bit 7,l                     ; check for norm
    jr NZ,doadd1                ; no normalize step, pack it up
    or a
    sla e
    rl d
    adc hl,hl
    dec c
    jr doadd1                   ; pack

; here for do add c has exponent of result (larger) b or b' has sign
.doadd
    push hl
    exx
    ex de,hl
    ex (sp),hl
    ex de,hl
    exx
    pop hl                      ; add the mantissas
    add hl,de
    exx
    adc hl,de
    push de
    exx
    ex (sp),hl
    exx
    pop de                      ; get least of sum
    xor a
    or a,h                      ; see if overflow to h
    jr Z,doadd1
    rr h
    rr l
    rr d
    rr e
    jr NC,doadd0
    set 0,e
.doadd0
    inc c
    jr Z,foverflow
.doadd1
; now pack result
    add hl,hl
    ld h,c                      ; exp
    rl b
    rr h
    rr l
    ex de,hl                    ; return DEHL
    ret

.foverflow
    ld a,b
    and 080h
    or 07fh
    ld d,a
    ld e,0ffh
    ld hl,0ffffh                ; max number
    scf                         ; error
    ret

; here one alignment needed
.alignone                       ; from fadd
    rr h
    rr l
    rr d
    rr e
    jr NC,alignone_a
    set 0,e
.alignone_a
    ex af,af
    jp M,fasub
    jr doadd

.alignzero
    ex af,af
    jp P,doadd
; here do subtract

; enter with aligned, smaller in hlde, exp of result in c'
; sign of result in b'
; larger number in hl'de'
; c is clear
.fasub
    push hl
    exx
    ex de,hl
    ex (sp),hl
    ex de,hl
    exx
    pop hl                      ; subtract the mantissas
    sbc hl,de
    exx
    sbc hl,de
    jr NC,noneg                 ; *** what if zero
; fix up and subtract in reverse direction
    exx
    ld a,b                      ; get reversed sign
    add hl,de                   ; reverse sub
    exx
    adc hl,de                   ; reverse sub
    exx
    ex de,hl
    or a
    sbc hl,de
    exx
    ex de,hl
    sbc hl,de
    ld b,a                      ; get proper sign to result
.noneg
    push de
    exx
    ex (sp),hl
    exx
    pop de                      ; get least part of result
; sub zero alignment from fadd
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
; now do normalize
    scf
    ex af,af                    ; if no C an alternate exit is taken


; enter here with af' carry clear for float functions md32_float32, md32_float32u
.md32_fsnormalize
; now begin normalize
    xor a
    or a,l
    jr Z,fa8a
    and 0f0h
    jp Z,S24L                   ; shift 24 bits, most significant in low nibble   
    jr S24H                     ; shift 24 bits in high
.fa8a
    xor a
    or a,d
    jr Z,fa8b
    and 0f0h
    jp Z,S16L                   ; shift 16 bits, most significant in low nibble
    jp S16H                     ; shift 16 bits in high
.fa8b
    xor a
    or a,e
    jp Z,normzero               ;  all zeros
    and 0f0h
    jp Z,S8L                    ; shift 8 bits, most significant in low nibble 
    jp S8H                      ; shift 8 bits in high

.S24H                           ; shift 24 bits 0 to 3 left, count in c
    sla e
    rl d
    rl l
    jr C,S24H1
    sla e
    rl d
    rl l
    jr C,S24H2
    sla e
    rl d
    rl l
    jr C,S24H3
    ld a,-3                     ; count
    jr normdone1                ; from normalize

.S24H1
    rr l
    rr d
    rr e                        ; reverse overshift
    ld a,c                      ; zero adjust
    jr normdone1_a

.S24H2
    rr l
    rr d
    rr e
    ld a,-1
    jr normdone1

.S24H3
    rr l
    rr d
    rr e
    ld a,-2
    jr normdone1

.S24L                           ; shift 24 bits 4-7 left, count in C
    sla e
    rl d
    rl l
    sla e
    rl d
    rl l
    sla e
    rl d
    rl l
    ld a,0f0h
    and a,l
    jp Z,S24L4more               ; if still no bits in high nibble, total of 7 shifts
    sla e
    rl d
    rl l
; 0, 1 or 2 shifts possible here
    sla e
    rl d
    rl l
    jr C,S24Lover1
    sla e
    rl d
    rl l
    jr C,S24Lover2
; 6 shift case
    ld a,-6
    jr normdone1

.S24L4more
    sla e
    rl d
    rl l
    sla e
    rl d
    rl l
    sla e
    rl d
    rl l
    sla e
    rl d
    rl l
    ld a,-7
    jr normdone1

.S24Lover1                      ; total of 4 shifts
    rr l
    rr d
    rr e                        ; correct overshift
    ld a,-4
    jr normdone1

.S24Lover2                      ; total of 5 shifts
    rr l
    rr d
    rr e
    ld a,-5                     ; this is the very worst case, drop through to .normdone1

; enter here to continue after normalize
; this path only on subtraction
; a has left shift count, lde has mantissa, c has exponent before shift
; b has original sign of larger number
;
.normdone1                      ; worst case from align to here
    add a,c                     ; exponent of result
    jr NC,normzero              ; if underflow return zero

.normdone1_a                    ; case of zero shift
    rl l
    rl b                        ; sign
    rra
    rr l
    ld h,a                      ; exponent
    ex de,hl                    ; return DEHL
    ex af,af
    ret

.normzero                       ; return zero
    ld hl,0
    ld d,h
    ld e,l
    ex af,af
    ret

; all bits in lower 4 bits of e (bits 0-3 of mantissa)
; shift 8 bits 4-7 bits left
; e, l, d=zero
.S8L
    sla e
    sla e
    sla e
    ld a,0f0h
    and a,e
    jp Z,S8L4more               ; if total is 7
    sla e                       ; guaranteed
    sla e                       ; 5th shift
    jr C,S8Lover1               ; if overshift
    sla e                       ; the shift
    jr C,S8Lover2
; total of 6, case 7 already handled
    ld l,e
    ld e,d                      ; zero
    ld a,-22
    jr normdone1

.S8Lover1                       ; total of 4
    rr e
    ld l,e
    ld e,d                      ; zero
    ld a,-20
    jr normdone1

.S8Lover2                       ; total of 5
    rr e
    ld l,e
    ld e,d                      ; zero
    ld a,-21
    jr normdone1

.S8L4more
    sla e
    sla e
    sla e
    sla e
    ld l,e
    ld e,d                      ; zero
    ld a,-23
    jr normdone1

; shift 16 bit fraction by 4-7
; l is zero, 16 bits number in de
.S16L
    sla e
    rl d
    sla e
    rl d
    sla e
    rl d                        ; 3 shifts
    ld a,0f0h
    and a,d
    jp Z,S16L4more              ; if still not bits n upper after 3
    sla e
    rl d                        ; guaranteed shift 4
    jp M,S16L4                  ; complete at 4
    sla e
    rl d
    jp M,S16L5                  ; complete at 5
    sla e
    rl d                        ; 6 shifts, case of 7 already taken care of must be good
    ld a,-14
    ld l,d
    ld d,e
    ld e,0
    jp normdone1

.S16L4
    ld a,-12
    ld l,d
    ld d,e
    ld e,0
    jp normdone1

.S16L5                          ; for total of 5 shifts left
    ld a,-13
    ld l,d
    ld d,e
    ld e,0
    jp normdone1

.S16L4more
    sla e
    rl d
    sla e
    rl d
    sla e
    rl d
    sla e
    rl d
    ld l,d
    ld d,e
    ld e,0
    ld a,-15
    jp normdone1
;
; worst case 68 to get past this section
; shift 0-3, l is zero , 16 bits in de
;
.S16H
    sla e
    rl d
    jr C,S16H1                   ; if zero
    jp M,S16H2                   ; if 1 shift
    sla e
    rl d
    jp M,S16H3                   ; if 2 ok
; must be 3
    sla e
    rl d
    ld l,d
    ld d,e
    ld e,0
    ld a,-11
    jp normdone1

.S16H1                          ; overshift
    rr d
    rr e
    ld l,d
    ld d,e
    ld a,-8
    ld e,0
    jp normdone1

.S16H2                          ; one shift
    ld l,d
    ld d,e
    ld a,-9
    ld e,0
    jp normdone1

.S16H3
    ld l,d
    ld d,e
    ld a,-10
    ld e,0
    jp normdone1

; shift 8 left 0-3
; number in e, l, d==zero
.S8H
    sla e
    jr C,S8H1                   ; jump if bit found in data
    sla e
    jr C,S8H2
    sla e
    jr C,S8H3
; 3 good shifts, number in a shifted left 3 ok
    ld l,e
    ld e,d                      ; zero
    ld a,-19
    jp normdone1

.S8H1
    rr e                        ; correct overshift
    ld l,e
    ld e,d
    ld a,-16                    ; zero shifts
    jp normdone1

.S8H2
    rr e                        ; correct overshift
    ld l,e
    ld e,d
    ld a,-17                    ; one shift
    jp normdone1

.S8H3
    rr e                        ; correct overshift
    ld l,e
    ld e,d    
    ld a,-18
    jp normdone1                ; worst case S8H
