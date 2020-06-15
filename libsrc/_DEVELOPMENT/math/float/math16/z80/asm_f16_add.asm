;
;  feilipu, 2020 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_add - z80 half floating point add 16-bit mantissa
;-------------------------------------------------------------------------
;
; 1) first section: unpack from f24_add: to sort:
;    one unpacked number in dehl the other in dehl'
;    unpacked format: exponent in d, sign in e[7], mantissa in hl
;         in addition af' holds e xor e' used to test if add or sub needed
;
; 2) second section: sort from sort to align, sets up smaller number in de hl and larger in de' hl'
;    This section sorts out the special cases:
;       to alignzero - if no alignment (right) shift needed
;           alignzero has properties: up to 15 normalize shifts needed if signs differ
;                                     not know which mantissa is larger for different signs until sub performed
;                                     no alignment shifts needed
;       to alignone  - if one alignment shift needed
;           alignone has properties: up to 15 normalize shifts needed if signs differ
;                                    mantissa aligned is always smaller than other mantissa
;                                    one alignment shift needed
;       to align     - 2 to 15 alignment shifts needed
;           numbers aligned 2-15 have properties: max of 1 normalize shift needed
;                                                 mantissa aligned always smaller
;                                                 2-15 alignment shifts needed
;       number too small to add, return larger number (to doadd1)
;
; 3) third section alignment - aligns smaller number mantissa with larger mantissa
;    This section does the right shift. Lost bits shifted off, are tested. Up to 8 lost bits
;    are used for the test. If any are non-zero a one is or'ed into remaining mantissa bit 0.
;      align 2-15 - worst case right shift by 7 with lost bits
;
; 4) 4th section add or subtract
;
; 5) 5th section normalize in separate function asm_f24_normalize
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_inf

EXTERN asm_f24_normalize

PUBLIC asm_f16_add_callee
PUBLIC asm_f16_sub_callee

PUBLIC asm_f24_add_callee
PUBLIC asm_f24_sub_callee

PUBLIC asm_f24_add_f24

; enter here for floating asm_f16_sub_callee, x-y x on stack, y in hl, result in hl
.asm_f16_sub_callee
    ld a,h                      ; toggle the sign bit for subtraction
    xor 080h
    ld h,a

; enter here for floating asm_f16_add_callee, x+y, x on stack, y in hl, result in hl
.asm_f16_add_callee
    call asm_f24_f16            ; expand to dehl
    exx                         ; y     d'  = eeeeeeee e' = s-------
                                ;       hl' = 1mmmmmmm mmmmmmmm
    pop hl                      ; pop return address
    ex (sp),hl                  ; get second operand off of the stack,
                                ; return address on stack
    call asm_f24_f16            ; expand to dehl
                                ; x      d  = eeeeeeee e  = s-------
                                ;        hl = 1mmmmmmm mmmmmmmm
    call asm_f24_add_f24
    jp asm_f16_f24


; enter here for floating asm_f24_sub_callee, x-y x on stack, y in dehl, result in dehl
.asm_f24_sub_callee
    ld a,e                      ; toggle the sign bit for subtraction
    xor 080h
    ld e,a

; enter here for floating asm_f24_add_callee, x+y, x on stack, y in dehl, result in dehl
.asm_f24_add_callee
    exx                         ; y     d'  = eeeeeeee e' = s-------
                                ;       hl' = 1mmmmmmm mmmmmmmm
    pop bc                      ; pop return address
    pop hl                      ; x      d  = eeeeeeee e  = s-------
    pop de                      ;        hl = 1mmmmmmm mmmmmmmm
    push bc                     ; return address on stack


.asm_f24_add_f24
    ld a,e                      ; place op1.s in a[7]
    exx                         ; x mantissa: hl' = 1mmmmmmm mmmmmmmm
                                ; y mantissa: hl  = 1mmmmmmm mmmmmmmm
    xor e                       ; check if op1.s==op2.s
    ex af,af                    ; save results sign in f' (C clear in af')

; sort larger from smaller and compute exponent difference
    ld a,d
    exx                         ; y mantissa: hl' = 1mmmmmmm mmmmmmmm
                                ; x mantissa: hl  = 1mmmmmmm mmmmmmmm

    cp a,d                      ; nc if a>=b
    jp Z,alignzero              ; no alignment needed, exponents equal
    jr NC,sort                  ; if a larger than b
    ld a,d
    exx

.sort
    sub a,d                     ; positive difference in a
    cp  a,1                     ; if one difference, special case
    jp Z,alignone               ; smaller mantissa on top

    cp a,16                     ; check for too many shifts
    jr C,align                  ; if 15 or fewer shifts
; use other side, adding small quantity that can be ignored
    exx
    ret                         ; return f24 in DEHL

; align begin align count zero
.align
    srl a                       ; clear carry flag
    jr NC,al_2
    srl h                       ; 1 shift
    rr l
.al_2
    rra                         ; 1st lost bit to a[7]
    jr NC,al_3
    srl h                       ; 2 shifts
    rr l
    srl h
    rr l
.al_3
    rra                         ; 2nd lost bit to a[7,6]
    jr NC,al_4
    srl h                       ; 4 shifts
    rr l
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
; check for 8 bit right shift
.al_4
    rra                         ; 3rd lost bit to a[7,6,5]
    jr NC,al_5                  ; check shift by 8
; shift by 8 right
    ld a,l                      ; lost bits, keep only 8 most significant truncated bits
    ld l,h
    ld h,0                      ; upper zero
.al_5
    or a                        ; test truncated bits
    jr Z,aligndone
    set 0,l                     ; round based on lost bits

.aligndone
    ex af,af                    ; carry clear
    jp P,doadd
; here for subtract, smaller shifted right at least 2, so no more than
; one step of normalize
    push hl
    exx
    pop bc                      ; smaller to bc
    sbc hl,bc                   ; subtract the mantissas, carry cleared earlier
; difference larger-smaller in hl
; sign of result in d, exponent of result in e
    bit 7,h                     ; check for normalize
    ret NZ                      ; no normalize step, return f24 in DEHL
    add hl,hl
    dec d
    ret                         ; return f24 in DEHL

; here one alignment needed
.alignone                       ; from sort
    srl h
    rr l
    jr NC,alignone_a
    set 0,l
.alignone_a
    ex af,af
    jp M,dosub
;   jr doadd

; here for do add, d' has exponent of result (larger) e or e' has sign
.doadd
    xor a
    push hl
    exx
    pop bc
    add hl,bc                   ; add the mantissas
    adc a,a                     ; see if overflow from hl
    ret Z                       ; return if no overflow
    rra                         ; put carried bit back
    rr h
    rr l
    jr NC,doadd0
    set 0,l
.doadd0
    inc d                       ; test exponent overflow
    jp Z,asm_f24_inf
.doadd1
    ret                         ; return f24 in DEHL

.alignzero
    ex af,af
    jp P,doadd
;   jr dosub

; here do subtract

; enter with aligned, smaller in hl
; exp of result in d', sign of result in e'
; larger number in hl'
; C is clear
.dosub
    push hl
    exx
    pop bc
    sbc hl,bc                   ; subtract the mantissas
    jp NC,asm_f24_normalize     ; now begin to normalize with dehl

; fix up and subtract in reverse direction
    add hl,bc
    push hl
    exx

    pop bc
    or a
    sbc hl,bc
    ld a,e                      ; get reversed sign

; sub zero alignment from fadd
; difference larger-smaller in hl
; exponent of result in e sign of result in d
; now do normalize
    jp asm_f24_normalize        ; now begin to normalize with dehl

