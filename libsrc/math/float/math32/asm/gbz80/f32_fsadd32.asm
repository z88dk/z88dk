;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 expanded 32-bit mantissa add
;-------------------------------------------------------------------------
;
; B=exp, C[7]=sign, DEHL=mant (D=MSB)
;
; Same control as 8085.  Frame: ld hl,sp+n.  Park Y.HL before SP math.
; ld hl,sp+n clobbers C — save carry around adc/sbc.

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize32
EXTERN l_neg_dehl

PUBLIC m32_fsadd24x32, m32_fsadd32x32


;=======================================================================
; IEEE X → expanded 6-byte X, then same body as 32x32.
;=======================================================================
.m32_fsadd24x32
    push bc
    push de
    push hl                         ; Y | ret | ieee
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld bc,hl                        ; IEEE LSW
    ld hl,sp+10
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld de,hl                        ; DE = IEEE MSW
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

    push de
    ld de,hl                        ; DE = X.hl
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d
    pop de                          ; X.de
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d
    push bc                         ; X.bc | Y | ret | X.hl | X.de

    ld hl,sp+0
    ld c,(hl+)
    ld b,(hl)

    ld hl,sp+2
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+0
    ld (hl+),e
    ld (hl),d

    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+2
    ld (hl+),e
    ld (hl),d

    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+4
    ld (hl+),e
    ld (hl),d

    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+6
    ld (hl+),e
    ld (hl),d

    ld hl,sp+10
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+8
    ld (hl+),e
    ld (hl),d

    ld hl,sp+12
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d

    ld hl,sp+12
    ld (hl+),c
    ld (hl),b                       ; Y.hl Y.de Y.bc ret X.hl X.de X.bc

    pop hl
    pop de
    pop bc                          ; Y in regs; SP: ret, X.hl, X.de, X.bc
    jp a32_body


;=======================================================================
.m32_fsadd32x32
    ; Y in BC DEHL; SP: ret, X.hl, X.de, X.bc


;=======================================================================
.a32_body
    push hl                         ; park Y.hl; DE = Y.de stays
    ld hl,sp+9                      ; X.exp at +7 +2
    ld a,(hl)
    pop hl
    sub b                           ; A = X.exp - Y.exp
    jp Z,a32_addsub
    jp C,a32_x_small

    call a32_swap
    jp a32_align

.a32_x_small
    cpl
    inc a

.a32_align
    cp 24
    jp NC,a32_ret_y
    call a32_align_x

.a32_addsub
    push hl
    ld hl,sp+8                      ; X.sign at +6 +2
    ld a,(hl)
    pop hl
    xor c
    and 080h
    jp NZ,a32_sub

    call a32_addx
    jp NC,a32_ret_y
    call a32_shr1
    inc b
    ld a,b
    inc a
    jp Z,a32_ovf
    jp a32_ret_y

.a32_sub
    call a32_subx
    jp C,a32_sub_rev
.a32_sub_mag
    ld a,d
    or e
    or h
    or l
    jp Z,a32_zero
    ld a,d
    or a
    bit 7,a
    jr nz,a32_ret_y
    call m32_fsnormalize32
    jp a32_ret_y

.a32_sub_rev
    call l_neg_dehl
    ld a,c
    xor 080h
    ld c,a
    jp a32_sub_mag


.a32_ret_y
    push de
    push hl
    push bc                         ; +0 meta +2 low +4 high +6 ret +8 X
    ld hl,sp+0
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+8
    ld (hl+),e
    ld (hl),d                       ; X.hl := meta
    ld hl,sp+2
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d                       ; X.de := low
    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+12
    ld (hl+),e
    ld (hl),d                       ; X.bc := high
    ld hl,sp+6
    ld sp,hl                        ; drop park
    pop hl                          ; ret
    pop bc                          ; meta
    pop de                          ; low
    ; open-code ex (sp),hl — preserve BC/DE (helper is 148c)
    push de
    ld d,h
    ld e,l                          ; DE = ret
    ld hl,sp+2                      ; &high
    ld a,(hl)
    ld (hl),e
    ld e,a
    inc hl
    ld a,(hl)
    ld (hl),d
    ld h,a
    ld l,e                          ; HL = high; (sp+2) = ret
    pop de                          ; DE = low
    push hl                         ; DE=high, HL=low
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    ret


.a32_zero
    ld b,0
    ld c,0
    ld de,0
    ld hl,0
    jp a32_ret_y

.a32_ovf
    ld b,0ffh
    ld de,08000h
    ld hl,0
    jp a32_ret_y


;------------------------------------------------------------------------------
.a32_swap
    push af
    push bc
    push de
    push hl                         ; Y
    ; +0 Y.hl +2 Y.de +4 Y.bc +6 af +8 ret +10 body_ret +12 X.hl +14 X.de +16 X.bc

    ld hl,sp+16
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld bc,hl                        ; X.bc
    ld hl,sp+12
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl                         ; X.hl
    ld hl,sp+16                     ; X.de at +14 +2
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    pop hl                          ; BC DEHL = X

    push de
    push hl
    ; +0 X.hl +2 X.de +4 Y.hl +6 Y.de +8 Y.bc
    ; +10 af +12 ret +14 body +16 X.hl +18 X.de +20 X.bc

    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+16
    ld (hl+),e
    ld (hl),d
    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+18
    ld (hl+),e
    ld (hl),d
    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+20
    ld (hl+),e
    ld (hl),d

    pop hl
    pop de
    pop af
    pop af
    pop af
    pop af                          ; expdiff
    ret


;------------------------------------------------------------------------------
.a32_align_x
    push bc
    push de
    push hl
    ld b,a                          ; bit count
    ; +0 L.hl +2 L.de +4 L.bc +6 ret +8 body_ret +10 X.hl +12 X.de +14 X.bc

    push bc
    ld hl,sp+12                     ; X.hl at +10 +2
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld bc,hl
    ld hl,sp+14
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    ld hl,bc                        ; DEHL = small
    pop bc                          ; B = count

    ld a,b
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
    ld l,a
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
    ld l,a
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
    ld l,a
.a32_aln
    dec b
    jp NZ,a32_alp

.a32_al_store
    ld bc,de                        ; park small.de
    push hl                        ; DE = small.hl
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    ld hl,sp+10
    ld (hl+),e
    ld (hl),d                       ; X.hl
    ld hl,sp+12
    ld (hl+),c
    ld (hl),b                       ; X.de
    pop hl
    pop de
    pop bc
    ret


;------------------------------------------------------------------------------
; DEHL += stack X.mant.  CF set if bit 32 overflowed.
;------------------------------------------------------------------------------
.a32_addx
    push bc                         ; meta
    ld bc,de                        ; Y.de
    push hl                         ; Y.hl
    ld hl,sp+8                      ; X.hl at +6 +2
    ld e,(hl+)
    ld d,(hl)
    pop hl
    add hl,de                       ; sum.hl, CF
    ld a,0
    rla                             ; A = cy
    push hl                         ; sum.hl
    ld e,a                          ; E = cy
    ld hl,sp+10                     ; X.de at +8 +2
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; HL = X.de
    ld a,e
    rra                             ; restore cy
    ld a,c
    adc a,l
    ld c,a
    ld a,b
    adc a,h
    ld b,a
    pop hl
    ld de,bc
    pop bc
    ret


;------------------------------------------------------------------------------
; DEHL -= stack X.mant.  CF set if borrow.
;------------------------------------------------------------------------------
.a32_subx
    push bc
    ld bc,de
    push hl
    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)                       ; DE = X.hl
    pop hl                          ; Y.hl
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a                          ; HL = diff.hl, CF
    ld a,0
    rla
    push hl
    ld e,a                          ; E = borrow
    ld hl,sp+10
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; X.de
    ld a,e
    rra
    ld a,c
    sbc a,l
    ld c,a
    ld a,b
    sbc a,h
    ld b,a
    pop hl
    ld de,bc
    pop bc
    ret


;------------------------------------------------------------------------------
.a32_shr1
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

