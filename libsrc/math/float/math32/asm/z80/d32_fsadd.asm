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
;-------------------------------------------------------------------------
; m32_fsadd - z80, z180, z80n floating point add
; m32_fssub - z80, z180, z80n floating point subtract
;-------------------------------------------------------------------------
;
; 1) first section: unpack from F_add: to sort:
;    one unpacked number in hldebc the other in hl'de'bc'
;    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
;         in addition af' holds b xor b' used to test if add or sub needed
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
;
; 4) 4th section add or subtract
;
; 5) 5th section normalize in separate file d32_fsnormalize.asm
;
; 6) 6th section pack up in separate file d32_fsnormalize.asm
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize
EXTERN m32_fsconst_pnan

PUBLIC m32_fssub, m32_fssub_callee
PUBLIC m32_fsadd, m32_fsadd_callee


; enter here for floating subtract, x-y x on stack, y in dehl, result in dehl
.m32_fssub
    ld a,d                      ; toggle the sign bit for subtraction
    xor 080h
    ld d,a


; enter here for floating add, x+y, x on stack, y in dehl, result in dehl
.m32_fsadd
    ex de,hl                    ; DEHL -> HLDE
    ld b,h                      ; place op1.s in b[7]

    add hl,hl                   ; unpack op1
    ld c,h                      ; save op1.e in c

    ; Implicit 1: CF=(exp!=0). 255+exp carries iff exp!=0 (subnormals/zero keep CF=0).
    ld a,255
    add a,h
    rr l                        ; rotate in op1.m's implicit bit
    ld a,b                      ; place op1.s in a[7]

    exx

    pop bc                      ; get second operand off of the stack (preserve stack)
    pop de
    pop hl                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    push hl
    push de
    push bc
    jp farejoin


; enter here for floating subtract callee, x-y x on stack, y in dehl, result in dehl
.m32_fssub_callee
    ld a,d                      ; toggle the sign bit for subtraction
    xor 080h
    ld d,a


; enter here for floating add callee, x+y, x on stack, y in dehl, result in dehl
.m32_fsadd_callee
    ex de,hl                    ; DEHL -> HLDE
    ld b,h                      ; place op1.s in b[7]

    add hl,hl                   ; unpack op1
    ld c,h                      ; save op1.e in c

    ; Implicit 1: CF=(exp!=0). 255+exp carries iff exp!=0 (subnormals/zero keep CF=0).
    ld a,255
    add a,h
    rr l                        ; rotate in op1.m's implicit bit
    ld a,b                      ; place op1.s in a[7]

    exx

    pop hl                      ; pop return address
    pop de                      ; get second operand off of the stack
    ex (sp),hl                  ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm; ret → stack

.farejoin
    ld b,h                      ; save op2.s in b[7]

    add hl,hl                   ; unpack op2
    ld c,h                      ; save op2.e in c

    xor b                       ; check if op1.s==op2.s
    ex af,af                    ; save results sign in f' (C clear in af')

    ; Implicit 1: CF=(exp!=0). 255+exp carries iff exp!=0 (subnormals/zero keep CF=0).
    ld a,255
    add a,h
    rr l                        ; rotate in op2.m's implicit bit
    xor a
    ld h,a                      ; op2 mantissa: h = 00000000, lde = 1mmmmmmm mmmmmmmm mmmmmmmm
    exx
    ld h,a                      ; op1 mantissa: h = 00000000, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ; cold: either exp 255 (Inf/NaN).  Finite path: 2×(inc/jp) + 2×exx.
    ld a,c
    inc a
    jp Z,add_spec1              ; op1 exp was 255
    exx
    ld a,c
    inc a
    jp Z,add_spec2              ; op2 exp was 255
    exx

; sort larger from smaller and compute exponent difference
    ld a,c
    exx
    cp a,c                      ; nc if a>=c
    jp Z,alignzero              ; no alignment needed, mantissas equal
    jr NC,sort                  ; if a larger than c
    ld a,c
    exx
.sort
    sub a,c                     ; positive difference in a
    cp  a,1                     ; if one difference, special case
    jp Z,alignone               ; smaller mantissa on top

    cp a,24                     ; check for too many shifts
    jr C,align                  ; if 23 or fewer shifts
; use other side, adding small quantity that can be ignored
    exx
    jp doadd1                   ; pack result

; align begin align count zero
.align
    srl a                       ; clear carry flag
    jr NC,al_2
    srl h
    rr l
    rr de
.al_2
    rra                         ; 1st lost bit to a
    jr NC,al_3
    srl h
    rr l
    rr de
    rr hl
    rr de
.al_3
    rra                         ; 2nd lost bit to a
    jr NC,al_4
    srl h
    rr l
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
    or a                        ; test lost bits
    ld e,d
    ld d,l
    ld hl,0                     ; upper zero
    jr Z,aldone
    set 0,e                     ; lost bits
    jr aldone

; here possible 16
.al_5
    rra                         ; shift in a zero, lost bits in 6,5,4
    jr NC,al_6                  ; no shift by 16
; here shift by 16
; toss sticky collected in A (too remote after >>16).  Match the >>8
; path: only the byte leaving through D counts.  H may still hold bits
; from the 2-/4-bit unroll steps — those are also below the kept sticky
; window after >>16, so do not OR them in (issue #3043 Q2).
    ld a,d                      ; lost high byte of the lower half
    or a                        ; test D only
    ld e,l
    ld d,0
    ld h,d                      ; hl zero
    ld l,d
    jr Z,aldone
    set 0,e                     ; jam sticky
    jr aldone

; here no 8 or 16 shift: sticky in A bits 6..4 plus any bits left in H
; from the 2-/4-bit unrolled right shifts (still within the jam window)
.al_6
    or a,h                      ; test lost bits
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
    rr hl
    rr de
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
    rr hl
    ex de,hl                    ; return DEHL
    ret

.foverflow
    ld a,b
    and 080h
    or 07fh                     ; max exponent, preserve sign
    ld d,a
    ld e,080h                   ; IEEE infinity (zero mantissa)
    ld hl,0
    scf                         ; error
    ret

    ; ---- cold specials (mant NaN: L[6:0]|D|E after unpack) ----
    ; primary=op1, shadow=op2 on entry to add_spec1; primary=op2 for add_spec2

.add_spec1                      ; op1 exp 255
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; op1 NaN
    exx
    ld a,c
    inc a
    jr NZ,add_ret_inf1          ; Inf + finite → Inf (op1)
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; op2 NaN
    ex af,af
    jp M,m32_fsconst_pnan       ; Inf − Inf → NaN
.add_ret_inf1
    exx                         ; op1 primary: sign in b
    ld a,b
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    ret

.add_spec2                      ; op2 exp 255, op1 finite; primary=op2
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; op2 NaN
    ld a,b                      ; Inf + finite → Inf (op2)
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    ret

; here one alignment needed
.alignone                       ; from fadd
    srl h
    rr l
    rr de
    jr NC,alignone_a
    set 0,e
.alignone_a
    ex af,af
    jp M,fasub
    jp doadd                    ; was jr; specials after foverflow lengthened range

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
; full normalize (0..23 left shifts).  m32_fsnormalize ends with
; `ex af,af; ret`, so F' becomes the public flags.  CF clear = success
; (overflow already took .foverflow with scf).  Do not scf here — that
; left CF set on every fully-normalized add/sub result (#3043 Q1).
    or a                        ; CF=0 for return via normalize
    ex af,af

    jp m32_fsnormalize

