;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;
;-------------------------------------------------------------------------
; F_add - Rabbit floating point add
;-------------------------------------------------------------------------
; 1) first section: unpack from F_add: to sort: 78 clocks
;    one unpacked number in hldebc the other in hl'de'bc'
;    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
;         in addition af' holds  b xor b' used to test if add or sub needed
;
; 2) second section: sort from sort to align, sets up smaller number in hldebc and larger in hl'de'bc'
;    This section sorts out the special cases:
;       to alignzero - if no alignment (right) shift needed (11 clocks)
;           alignzero has properties: up to 23 normalize shifts needed if signs differ
;                                     not know which mantissa is larger for different signs until sub performed
;                                     no alignment shifts needed
;       to alignone  - if one alignment shift needed (31 clocks)
;           alignone has properties: up to 23 normalize shifts needed if signs differ
;                                    mantissa aligned is always smaller than other mantissa
;                                    one alignment shift needed
;       to align     - 2 to 23 alignment shifts needed (40 clocks)
;           numbers aligned 2-23 have properties: max of 1 normalize shift needed
;                                                 mantissa aligned always smaller
;                                                 2-23 alignment shifts needed
;       number too small to add, return larger number (to doadd1)
;
; 3) third section alignment - aligns smaller number mantissa with larger mantissa
;    This section does the right shift. Lost bits shifted off, are tested. Up to 8 lost bits
;    are used for the test. If any are non-zero a one is or'ed into remaining mantissa bit 0.
;      align 2-23 - worst case 101 clocks (right shift by 7 with lost bits)
; 4) 4th section add or subtract
;
; 5) 5th section post normalize - worst case 76 clocks for 7 left
;
; 6) 6th section pack up - 41 clocks
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC md32_fssub
PUBLIC md32_fsadd
PUBLIC md32_fsnormalize

; enter here for floating subtract, x-y x on stack, y in bcde
.md32_fssub
    ld a,b                      ; toggle the sign bit for subtraction
    xor 080h
    ld b,a

; enter here for floating add, x+y, x on stack, y in bcde, result in bcde
.md32_fsadd
    ld h,b
    ld l,c

    add hl,hl                   ; unpack op1
    ld c,h                      ; save op1.e in c

    ld a,h
    or a
    jr Z,faunp1                 ; add implicit bit if op1.e!=0
    scf

.faunp1
    rr l                        ; rotate in op1.m's implicit bit

    ld a,b                      ; place op1.e in a

    exx

    ld hl,(sp+3)                ; get op2 from stack
    ex de,hl
    ld hl,(sp+5)

    ld b,h                      ; save op2.s in b[7]

    add hl,hl                   ; unpack op2
    ld c,h                      ; save op1.e in c

    xor b                       ; check if op1.s==op2.s
    ex af,af                    ; save results sign in f' (C clear in af')

    ld a,h
    or a
    jr Z,faunp2                 ; add implicit bit if op2.e!=0
    scf

.faunp2
    rr l                        ; rotate in op2.m's implicit bit
    xor a
    ld h,a
    exx
    ld h,a

; sort larger from smaller and compute exponent difference
.sort
    ld a,c
    exx
    cp a,c                      ; nc if a>=c
    jp Z,alignzero              ; 11 no alignment mantissas equal
    jr NC,sort2                 ; if a larger then c
    ld a,c
    exx
.sort2
    sub a,c                     ; positive difference in a
    cp  a,1                     ; if one difference, special case
    jp Z,alignone               ; 31 smaller mantissa on top

    cp a,24                     ; check for too many shifts
    jr C,align                  ; if 23 or fewer shifts
; use other side, adding small quantity that can be ignored
    exx
    jr doadd1                  ; pack result

; align begin align count zero
.align
    or a
    rra
    jr nc,al_2
    ccf
    rr hl
    rr de  ; 15
.al_2
    rra                         ; 1st lost bit to a
    jr NC,al_3
    ccf
    rr hl
    rr de
    rr hl
    rr de
.al_3
    rra                         ; 2nd lost bit to a
    jr NC,al_4
    ccf
    rr hl
    rr de
    rr hl
    rr de
    rr hl
    rr de
    rr hl
    rr de
; check for 8 bit right shift
.al_4
    rra                         ;  3rd lost bit to a check shift by 8,
    jr NC,al_5
; shift by 8 right, no 16 possible
    ld a,e                      ; lost bits, keep only 8
    ld e,d
    ld d,l
    ld l,0
    ld h,l                      ; upper zero
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
    ld l,d                      ; lost bits
    ld d,0
    bool hl                     ; 1 if any lost bits
    ex de,hl
    or hl,de
    ex de,hl
    rr hl                       ; hl zero
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

    ex de',hl                   ; subtract the mantissas
    sbc hl,de
    exx
    sbc hl,de
    ex de,hl'
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
    bit 7,l                     ; check for norm
    jr NZ,doadd1                ; no normalize step, pack it up
    or a
    rl de
    adc hl,hl
    dec c
    jr doadd1                   ; pack

; here for do add c has exponent of result (larger) b or b' has sign
.doadd
    ex de',hl                   ; add the mantissas
    add hl,de
    exx
    adc hl,de
    ex de,hl'                   ; get least of sum
    xor a
    or a,h                      ; see if overflow to h
    jr Z,doadd1
    rr hl
    rr de
    jr NX,doadd0
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
    ld b,h
    ld c,l
    ret                         ; lret

.foverflow
   ld a,b
   and 080h
   or 07fh
   ld b,a
   ld c,0ffh
   ld de,0ffffh                 ; max number
;
    ld hl,-ERR_FLOATOVERFLOW    ; Floating Overflow
    push hl
    call exception
    add sp, 2
    call _xexit
;
    ret                         ; lret

; here one alignment needed
.alignone                       ; from fadd
   rr hl
   rr de
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
    ex de',hl                   ; subtract the mantissas
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
    ex de,hl'                   ; 23 if no fixup, 55 if fixup,  get least part of result
; sub zero alginment 153 from fadd
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
; now do normalize
    scf
    ex af,af                    ; if no C an alternate exit is taken


; enter here with af' carry clear for float function Bl_Bf, Bg_Bf
.md32_fsnormalize
; now begin normalize
    xor a
    or l
    jr Z,fa8a
;   jp novf,S24L                ; shift 24 bits, most significent in low nibble
    jp PO,S24L  
;---     
    jr S24H                     ; shift 24 bits in high
.fa8a
    or d
    jr Z,fa8b
;   jp novf,S16L                ; shift 16 bits in low nibble
    jp PO,S16L
;---
    jp S16H                     ; shift 16 bits in high
.fa8b
    or e
    jr Z,normzero               ;  all zeros
;   jp novf,S8L
    jp PO,S8L
;---
    jp S8H


; 19
.S24H                           ; shift 24 bits 0 to 3 left, count in c
   rl de
   rla
   jr c,S24H1
   rl de
   rla
   jr c,S24H2
   rl de
   rla
   jr c,S24H3
   ld l,a                       ; most
   ld a,-3                      ; count
   jr normdone1                 ; from normalize
.S24H1
   rra
   rr de                        ; reverse overshift
   ld l,a
   ld a,c                       ; zero adjust
   jr normdone1_a
.S24H2
   rra
   rr de
   ld l,a
   ld a,-1
   jr normdone1
.S24H3
   rra
   rr de
   ld l,a
   ld a,-2
   jr normdone1

.S24L                           ; shift 24 bits 4-7 left, count in C
   rl de
   rla
   rl de
   rla
   rl de
   rl a                         ; different shift, 4 clocks, sets flags
;  jp   novf,S24L4more          ; if still no bits in high nibble, total of 7 shifts
   jp PO,S24L4more
;---
   rl de
   rla
; 0, 1 or 2 shifts possible here
   rl de
   rla
   jr C,S24Lover1
   rl de
   rla
   jr c,S24Lover2
; 6 shift case
   ld l,a
   ld a,-6
   jr normdone1
.S24L4more
   rl de
   rla
   rl de
   rla
   rl de
   rla
   rl de
   rla
   ld l,a
   ld a,-7
   jr normdone1
.S24Lover1                      ; total of 4 shifts
   rra
   rr de                        ; correct overshift
   ld l,a
   ld a,-4
   jr normdone1
.S24Lover2                      ; total of 5 shifts
   rra
   rr de
   ld l,a
   ld a,-5                      ; this is the very worst case, drop through to .normdone1

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
    ld b,h
    ld c,l
    ex af,af
    ret                         ; lret
.normzero                       ; return zero
    bool hl
    rr hl
    ex de,hl
    ld b,d
    ld c,e
    ex af,af
    ret                         ; lret

; all bits in lower 4 bits of e (bits 0-3 of mantissa)
; shift 8 bits 4-7 bits left
; a has e, l, d=zero
.S8L                            ; 30  - worst 76 clocks to get past this section
    rla
    rla
    rl a                        ; different shift rr a not rra, sets novf flag if upper 4 bits zero
;   jp novf,S8L4more            ; if total is 7
    jp PO,S8L4more
;---
    rla                         ; guaranteed
    rla                         ; 5th shift
    jr C,S8Lover1               ; if overshift
    rla                         ; the shift
    jr C,S8Lover2
; total of 6, case 7 already handled
    ld l,a
    ld e,d                      ; zero
    ld a,-22
    jr normdone1
.S8Lover1                       ; total of 4
    rra
    ld l,a
    ld e,d                      ; zero
    ld a,-20
    jr normdone1
.S8Lover2                       ; total of 5
    rra
    ld l,a
    ld e,d                      ; zero
    ld a,-21
    jr normdone1
.S8L4more
    rla
    rla
    rla
    rla
    ld l,a
    ld e,d                      ; zero
    ld a,-23
    jr normdone1

; worst 73 clocks to get past this section
; shift 16 bit fraction by 4-7
; d is copied to a, l is zero, number in de
.S16L
   rl de
   rl de
   rl de                        ; 3 shifts
;  jp   novf,S16L4more          ; if still not bits n upper after 3
   jp PO,S16L4more
;---
   rl de                        ; guaranteed shift 4
   jp M,S16L4                   ; complete at 4
   rl de
   jp M,S16L5                   ; complete at 5
   rl de                        ; 6 shifts, case of 7 already taken care of must be good
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
   jp   normdone1
.S16L5                          ; for total of 5 shifts left
   ld a,-13
   ld l,d
   ld d,e
   ld e,0
   jp normdone1

.S16L4more
   rl de
   rl de
   rl de
   rl de
   ld l,d
   ld d,e
   ld e,0
   ld a,-15
   jp normdone1
;
; worst case 68 to get past this section
; shift 0-3, a is d, l is zero , 16 bits in de
;
.S16H
   rl de
   jr C,S16H1                   ; if zero
   jp M,S16H2                   ; if 1 shift
   rl de
   jp M,S16H3                   ; if 2 ok
; must be 3
   rl de
   ld l,d
   ld d,e
   ld e,0
   ld a,-11
   jp   normdone1
.S16H1                          ; overshift
   rr de
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
;
; shift 8 left 0-3  worst case 71 clocks to get past this section
; number in a,e, l, d==zero
.S8H
   rla
   jr C,S8H1                    ; jump if bit found in data
   rla
   jr C,S8H2
   rla
   jr C,S8H3
; 3 good shifts, number in a shifted left 3 ok
   ld l,a
   ld e,d                       ; zero
   ld a,-19
   jp normdone1
.S8H1
   rra                          ; correct over shift
   ld l,a
   ld a,-16
   ld e,d                       ; zero shifts
   jp normdone1
.S8H2
   rra                          ; correct over shift
   ld l,a
   ld e,d
   ld a,-17                     ; one shift
   jp normdone1
.S8H3
   rra                          ; correct overshift
   ld l,a
   ld a,-18
   ld e,d
   jp normdone1                 ; worst case S8H

