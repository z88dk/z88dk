;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsadd32 - z80, z180, z80n floating point add 32-bit mantissa
;-------------------------------------------------------------------------
;
; 1) first section: unpack from F_add: to sort:
;    one unpacked number in hldebc the other in hl'de'bc'
;    unpacked format: mantissa= hlde, exponent in b, sign in c[7]
;         in addition af' holds c xor c' used to test if add or sub needed
;
; 2) second section: sort from sort to align, sets up smaller number in bc hlde and larger in bc' hl'de'
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
; 5) 5th section normalize in separate file d32_fsnormalize32.asm
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize32

PUBLIC m32_fsadd24x32, m32_fsadd32x32


; enter here for floating add32+32, x+y, x on stack, y in dehl, result in dehl
.m32_fsadd32x32
    ex de,hl                    ; dehl -> hlde
    ld a,c                      ; place op1.s in a[7]
    ex af,af

    exx                         ; first b' = eeeeeeee c' = s-------
                                ;    hlde' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm

    pop af                      ; pop return address
    pop de                      ; get second operand off of the stack
    pop hl                      ; second b = eeeeeeee c  = s-------
    pop bc                      ;     hlde = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
    push af                     ; return address on stack

    ex af,af
    xor c                       ; check if op1.s==op2.s
    ex af,af                    ; save results sign in f' (C clear in af')

    ld a,b
    or a
    jr faunp1


; enter here for floating add24+32 callee, x+y, x on stack, y in bcdehl, result in bcdehl
.m32_fsadd24x32
    ex de,hl                    ; dehl -> hlde
    ld a,c                      ; place op1.s in a[7]

    exx                         ; first b' = eeeeeeee c' = s-------
                                ;   hl'de' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm

    pop bc                      ; pop return address
    pop de                      ; get second operand off of the stack
    pop hl                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    push bc                     ; return address on stack

    ld c,h                      ; save op2.s in c[7]

    add hl,hl                   ; unpack op2
    ld b,h                      ; save op2.e in b

    xor c                       ; check if op1.s==op2.s
    ex af,af                    ; save results sign in f' (C clear in af')

    ld a,h
    or a
    jr Z,faunp2                 ; add implicit bit if op2.e!=0
    scf

.faunp2
    rr l                        ; rotate in op2.m's implicit bit
    ld h,l
    ld l,d
    ld d,e
    ld e,0

.faunp1
    exx                         ; op2 mantissa: hlde' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
                                ; op1 mantissa: hlde  = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm

; sort larger from smaller and compute exponent difference
    ld a,b
    exx
    cp a,b                      ; nc if a>=b
    jp Z,alignzero              ; no alignment needed, mantissas equal
    jr NC,sort                  ; if a larger than b
    ld a,b
    exx
.sort
    sub a,b                     ; positive difference in a
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
    rr d
    rr e
.al_2
    rra                         ; 1st lost bit to a[7]
    jr NC,al_3
    srl h
    rr l
    rr d
    rr e
    srl h
    rr l
    rr d
    rr e
.al_3
    rra                         ; 2nd lost bits to a[7,6]
    jr NC,al_4
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
    rr e
; check for 8 bit right shift
.al_4
    rra                         ;  3rd lost bit to a[7,6,5], check shift by 8,
    jr NC,al_5
; shift by 8 right, no 16 possible
    ld a,e                      ; lost bits in a, keep only 8 most significant
    ld e,d
    ld d,l
    ld l,h
    ld h,0                      ; upper zero
    or a
    jr Z,aligndone
    set 0,e                     ; lost bits
    jr aligndone

; here possible 16
.al_5 
    rra                         ; 4th lost bit in 6,5,4,3
    jr NC,al_6                  ; no shift by 16
; here shift by 16
; toss lost bits in a which are remote for 16 shift
; consider only lost bits in d
    ld a,d                      ; lost bits in a, keep only 8 most significant
    ld e,l
    ld d,h
    ld hl,0                     ; hl zero

; here no 8 or 16 shift, lost bits in a-reg bits 6,5,4, other bits zero's
.al_6
    or a                        ; test lost bits
    jr Z,aligndone
    set 0,e                     ; lost bits
;   jr aligndone
    
; align done here
.aligndone
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
    bit 7,h                     ; check for norm
    jr NZ,doadd1                ; no normalize step, pack it up
    sla e
    rl d
    adc hl,hl
    dec b
    jr doadd1                   ; pack

; here for do add c has exponent of result (larger) b or b' has sign
.doadd
    xor a
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
    adc a,a                     ; see if overflow from h
    push de
    exx
    ex (sp),hl
    exx
    pop de                      ; get least of sum
    jr Z,doadd1                 ; if no overflow
    rra                         ; recover carry
    rr h
    rr l
    rr d
    rr e
    jr NC,doadd0
    set 0,e
.doadd0
    inc b
    jr Z,foverflow
.doadd1
    ex de,hl                    ; return BC DEHL
    ret

.foverflow
    ld b,07fh
    ld de,0ffffh
    ld hl,0ffffh                ; max number
    scf                         ; error
    ret

; here one alignment needed
.alignone                       ; from fadd
    srl h
    rr l
    rr d
    rr e
    jr NC,alignone_a
    set 0,e
.alignone_a
    ex af,af
    jp M,dosub
    jr doadd

.alignzero
    ex af,af
    jp P,doadd
; here do subtract

; enter with aligned, smaller in hlde, exp of result in b'
; sign of result in c'
; larger number in hl'de'
; C is clear
.dosub
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
    ld a,c                      ; get reversed sign
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
    ld c,a                      ; get proper sign to result
.noneg
    push de
    exx
    ex (sp),hl
    exx
    pop de                      ; get least part of result
; sub zero alignment from fadd
; difference larger-smaller in hlde
; exponent of result in b sign of result in c
; now do normalize
    ex de,hl

    jp m32_fsnormalize32        ; now begin to normalize with bc dehl

