;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 expanded 32-bit mantissa add
; B=exp, C[7]=sign, DEHL=mant (D=MSB)
;
; Y stays in BC DEHL.  X stays on the stack.  No BSS.
;
; m32_fsadd32x32: Y in regs; stack X.hl X.de X.bc ret
; m32_fsadd24x32: Y in regs; stack IEEE X.HL X.DE ret
;                 expands X in place (+2) then joins 32x32 (net pop 4)
;
; After either prologue:
;   Y = larger-or-equal exponent (equal: Y is left / original Y)
;   stack = ret, small.hl, small.de, small.bc
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize32
EXTERN l_neg_dehl

PUBLIC m32_fsadd24x32, m32_fsadd32x32


;=======================================================================
; IEEE X → expanded 6-byte X, then same body as 32x32.
; Start:  ret, I.HL, I.DE
; Finish: ret, X.hl, X.de, X.bc     (IEEE overwritten, +2 for X.bc)
;=======================================================================
.m32_fsadd24x32
    push bc
    push de
    push hl                         ; Y | ret | ieee
    ld de,sp+8
    ld hl,(de)
    ld bc,hl                        ; IEEE LSW
    ld de,sp+10                     ; I.DE (no park push)
    ld hl,(de)
    ex de,hl                        ; DE = IEEE MSW
    ld hl,bc                        ; DEHL = IEEE X

    ld a,d
    and 080h
    ld c,a
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld b,a
    ld a,255
    add a,b
    ld a,e
    rra
    ld d,a
    ld e,h
    ld h,l
    ld l,0                          ; BC DEHL = expanded X

    ; ieee(4) → X.hl|X.de; push X.bc; rotate → Y|ret|X (same as fsmul24x32)
    push de
    ld de,sp+10
    ld (de),hl
    pop hl
    ld de,sp+10
    ld (de),hl
    push bc                         ; X.bc | Y | ret | X.hl | X.de

    ld de,sp+0
    ld hl,(de)
    ld bc,hl
    ld de,sp+2
    ld hl,(de)
    ld de,sp+0
    ld (de),hl
    ld de,sp+4
    ld hl,(de)
    ld de,sp+2
    ld (de),hl
    ld de,sp+6
    ld hl,(de)
    ld de,sp+4
    ld (de),hl
    ld de,sp+8
    ld hl,(de)
    ld de,sp+6
    ld (de),hl
    ld de,sp+10
    ld hl,(de)
    ld de,sp+8
    ld (de),hl
    ld de,sp+12
    ld hl,(de)
    ld de,sp+10
    ld (de),hl
    ld hl,bc
    ld de,sp+12
    ld (de),hl                      ; Y.hl Y.de Y.bc ret X.hl X.de X.bc

    pop hl
    pop de
    pop bc                          ; Y in regs; SP: ret, X.hl, X.de, X.bc
    jp a32_body


;=======================================================================
.m32_fsadd32x32
    ; Y in BC DEHL; SP: ret, X.hl, X.de, X.bc


;=======================================================================
; Y in BC DEHL (large after sort).  SP: ret, small.hl, small.de, small.bc
; X.exp at +7, X.sign at +6.
;=======================================================================
.a32_body
    push hl
    ld hl,de                        ; park Y.de
    ld de,sp+9                      ; X.exp
    ld a,(de)
    ld de,hl                        ; restore Y.de
    pop hl
    sub b                           ; A = X.exp - Y.exp
    jp Z,a32_addsub                 ; equal: no swap, no align
    jp C,a32_x_small                ; X.exp < Y.exp

    ; X.exp > Y.exp: A = expdiff.  X becomes large (regs), Y → small slot.
    call a32_swap
    jp a32_align

.a32_x_small
    cpl
    inc a                           ; expdiff = Y.exp - X.exp

.a32_align
    cp 24
    jp NC,a32_ret_y                 ; small cannot affect large
    ; A = 1..23: right-shift small (stack), jam after each move
    call a32_align_x

.a32_addsub
    ; signs: X.bc at +6 (sign, exp)
    push hl
    ld hl,de                        ; park Y.de
    ld de,sp+8                      ; X.sign
    ld a,(de)
    ld de,hl
    pop hl
    xor c
    and 080h
    jp NZ,a32_sub

    call a32_addx
    jp NC,a32_ret_y                 ; no mant overflow
    ; sum overflowed: >>1, jam, exp++
    call a32_shr1
    inc b
    ld a,b
    inc a                           ; new exp == 255 (was 254)
    jp Z,a32_ovf
    jp a32_ret_y

.a32_sub
    call a32_subx
    jp C,a32_sub_rev                ; borrow: only possible if expdiff==0
.a32_sub_mag
    ld a,d
    or e
    or h
    or l
    jp Z,a32_zero
    ld a,d
    or a
    jp M,a32_ret_y                  ; already normalised
    call m32_fsnormalize32
    jp a32_ret_y

.a32_sub_rev
    call l_neg_dehl
    ld a,c
    xor 080h
    ld c,a
    jp a32_sub_mag


.a32_ret_y
    ; BC DEHL = result.  SP: ret, X.hl, X.de, X.bc
    ; Same shuffle as fsmul32 epilogue: park result, copy over X, drop park,
    ; pop so DEHL/BC are result and ret is on the stack.
    push de
    push hl
    push bc                         ; +0 meta +2 low +4 high +6 ret +8 X
    ld de,sp+0
    ld hl,(de)
    ld de,sp+8
    ld (de),hl                      ; X.hl := meta
    ld de,sp+2
    ld hl,(de)
    ld de,sp+10
    ld (de),hl                      ; X.de := low
    ld de,sp+4
    ld hl,(de)
    ld de,sp+12
    ld (de),hl                      ; X.bc := high
    ld de,sp+6
    ex de,hl
    ld sp,hl                        ; drop park; SP: ret, meta, low, high
    pop hl                          ; ret
    pop bc                          ; meta
    pop de                          ; low
    ex (sp),hl                      ; HL=high, (sp)=ret
    ex de,hl                        ; DE=high, HL=low
    ret


.a32_zero
    ld b,0
    ld c,0
    ld de,0
    ld hl,0
    jp a32_ret_y

.a32_ovf
    ld b,0ffh                       ; Inf exp; sign still in C
    ld de,08000h
    ld hl,0
    jp a32_ret_y


;------------------------------------------------------------------------------
; Swap Y (regs) with X (stack).  A = expdiff, preserved.
; CALL: SP = ret, body_ret, X.hl, X.de, X.bc
;------------------------------------------------------------------------------
.a32_swap
    push af
    push bc
    push de
    push hl                         ; Y
    ; +0 Y.hl +2 Y.de +4 Y.bc +6 af +8 ret +10 body_ret +12 X.hl +14 X.de +16 X.bc

    ld de,sp+16
    ld hl,(de)
    ld bc,hl                        ; X.bc
    ld de,sp+12
    ld hl,(de)
    push hl                         ; X.hl
    ld de,sp+16                     ; X.de at +14 +2
    ld hl,(de)
    ex de,hl
    pop hl                          ; BC DEHL = X

    push de
    push hl                         ; park X.mant; BC stays
    ; +0 X.hl +2 X.de +4 Y.hl +6 Y.de +8 Y.bc
    ; +10 af +12 ret +14 body +16 X.hl +18 X.de +20 X.bc

    ld de,sp+4
    ld hl,(de)
    ld de,sp+16
    ld (de),hl                      ; X.hl := Y.hl
    ld de,sp+6
    ld hl,(de)
    ld de,sp+18
    ld (de),hl
    ld de,sp+8
    ld hl,(de)
    ld de,sp+20
    ld (de),hl                      ; X.bc := Y.bc

    pop hl
    pop de                          ; large = old X; BC already
    ; SP: Y(6) af ret body X
    pop af
    pop af
    pop af                          ; drop Y park
    pop af                          ; expdiff
    ret


;------------------------------------------------------------------------------
; Right-shift stack small by A bits.  Jam lost bits into new LSB (L).
; Large meta in BC; large mant in DEHL — parked for the shift.
; CALL: SP = ret, body_ret, X.hl, X.de, X.bc
;------------------------------------------------------------------------------
.a32_align_x
    push bc                         ; large meta
    push de
    push hl                         ; large mant
    ; +0 L.hl +2 L.de +4 L.bc +6 ret +8 body_ret +10 X.hl +12 X.de +14 X.bc
    ; BC free until count is needed

    ld de,sp+10
    ld hl,(de)
    ld bc,hl                        ; X.hl
    ld de,sp+12
    ld hl,(de)
    ex de,hl                        ; DE = X.de
    ld hl,bc                        ; DEHL = small
    ld b,a                          ; bit count
    cp 16
    jp C,a32_al8
    sub 16
    ld b,a
    ld a,l
    or h
    ld hl,de
    ld de,0
    jp Z,a32_al8
    ld a,l
    or 1
    ld l,a                          ; jam after >>16
.a32_al8
    ld a,b
    or a
    jp Z,a32_al_store
    cp 8
    jp C,a32_alb
    sub 8
    ld b,a
    ld a,l
    or a
    ld l,h
    ld h,e
    ld e,d
    ld d,0
    jp Z,a32_alb
    ld a,l
    or 1
    ld l,a                          ; jam after >>8
.a32_alb
    ld a,b
    or a
    jp Z,a32_al_store
.a32_alp
    xor a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    jp NC,a32_aln
    ld a,l
    or 1
    ld l,a                          ; jam after >>1
.a32_aln
    dec b
    jp NZ,a32_alp

.a32_al_store
    ld bc,de                        ; park X.de (count done)
    ld de,sp+10
    ld (de),hl                      ; X.hl
    ld hl,bc
    ld de,sp+12
    ld (de),hl                      ; X.de
    pop hl
    pop de
    pop bc                          ; large restored
    ret


;------------------------------------------------------------------------------
; DEHL += stack X.mant.  CF set if bit 32 overflowed.
; CALL: SP = ret, body_ret, X.hl, X.de, X.bc
;------------------------------------------------------------------------------
.a32_addx
    push bc                         ; meta
    ; +0 meta +2 ret +4 body +6 X.hl +8 X.de
    ld bc,de                        ; Y.de
    ld de,sp+6
    push hl                         ; Y.hl
    ld hl,(de)
    ex de,hl                        ; DE = X.hl
    pop hl                          ; Y.hl
    add hl,de                       ; sum.hl, CF
    ld de,sp+8                      ; X.de (flags kept)
    push hl                         ; sum.hl
    ld hl,(de)                      ; X.de
    ld a,c
    adc a,l
    ld c,a
    ld a,b
    adc a,h
    ld b,a                          ; BC = sum.de, CF = overflow
    pop hl                          ; sum.hl
    ld de,bc
    pop bc                          ; meta
    ret


;------------------------------------------------------------------------------
; DEHL -= stack X.mant.  CF set if borrow (Y < X).
; Low word through A (keeps Y.de in BC); then sbc on DE.  Not sbc hl,bc.
;------------------------------------------------------------------------------
.a32_subx
    push bc                         ; meta
    ; +0 meta +2 ret +4 body +6 X.hl +8 X.de
    ld bc,de                        ; Y.de
    ld de,sp+6
    push hl                         ; Y.hl
    ld hl,(de)                      ; X.hl
    pop de                          ; Y.hl
    ld a,e
    sub l
    ld e,a
    ld a,d
    sbc a,h
    ld d,a                          ; DE = diff.hl, CF
    push de                         ; diff.hl
    ld de,sp+10                     ; X.de at +8 +2
    ld hl,(de)
    ld a,c
    sbc a,l
    ld c,a
    ld a,b
    sbc a,h
    ld b,a                          ; BC = diff.de
    pop hl
    ld de,bc
    pop bc                          ; meta
    ret


;------------------------------------------------------------------------------
; DEHL >>= 1, jam lost bit into L.  CF from last rra discarded (already jammed).
;------------------------------------------------------------------------------
.a32_shr1
    ; add overflow only: inject 1 at D.7, jam lost L.0
    scf
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ret NC
    ld a,l
    or 1
    ld l,a
    ret
