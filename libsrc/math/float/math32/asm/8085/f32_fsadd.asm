;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_fsadd / m32_fssub - 8085 IEEE single add/sub
;-------------------------------------------------------------------------
; Slot (6 bytes) after unpack:
;   +0 L = mant MSB (hidden 1 if exp!=0)
;   +1     0
;   +2 E = mant LSB
;   +3 D = mant mid
;   +4     exp
;   +5     sign (bit 7)
;
; Frame after both unpacks:
;   +0  X slot (6)
;   +6  Y slot (6)
;  +12  drop_flag (2)
;  +14  ret (2)
;  +16  left IEEE if callee (4)
;
; X is kept as the larger-or-equal exponent operand.
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize

PUBLIC m32_fssub, m32_fssub_callee
PUBLIC m32_fsadd, m32_fsadd_callee


.m32_fssub
    ld a,d
    xor 080h
    ld d,a
.m32_fsadd
    xor a
    jp fa_start

.m32_fssub_callee
    ld a,d
    xor 080h
    ld d,a
.m32_fsadd_callee
    ld a,1


.fa_start
    push af                         ; drop flag (0=non-callee, 1=callee)
    call unpack_push                ; Y from DEHL
    ld de,sp+10
    call load_ieee                  ; left IEEE → DEHL
    call unpack_push                ; X from left

    ; If Y.exp >= X.exp, swap so X has larger-or-equal exp
    ld de,sp+4
    ld a,(de)                       ; X.exp
    ld b,a
    ld de,sp+10
    ld a,(de)                       ; Y.exp
    cp b
    call NC,swap6

    ; expdiff = X.exp - Y.exp
    ld de,sp+4
    ld a,(de)
    ld b,a
    ld de,sp+10
    ld a,(de)
    ld c,a
    ld a,b
    sub c                           ; A = expdiff
    cp 24
    jp NC,pack_x                    ; Y negligible

    call align_y                    ; right-shift Y by A (sticky LSB)

    ; same sign → add; different → sub
    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+11
    ld a,(de)
    xor b
    and 080h
    jp NZ,do_sub

    call mant_add                   ; X += Y; A = carry out
    or a
    jp Z,pack_x
    call mant_shr1
    ld de,sp+4
    ld a,(de)
    inc a
    ld (de),a
    jp Z,ovf
    jp pack_x

.do_sub
    call mant_sub                   ; |X| - |Y| (or reverse + flip sign)
    call mant_zero
    jp Z,ret0
    call load_x_regs                ; B=sign C=exp H=0 LDE=mant
    call m32_fsnormalize            ; packed DEHL
    jp epi

.pack_x
    call load_x_regs
    ; pack: h=0, lde=mant with hidden 1, c=exp, b=sign
    ld a,l
    rla                             ; eject hidden → C
    ld l,a
    ld a,b
    rla                             ; sign → C
    ld a,c                          ; exp
    rra                             ; sign into A[7]
    ld h,a
    ld a,l
    rra
    ld l,a
    ex de,hl                        ; DEHL IEEE
    jp epi

.ovf
    ld de,sp+5
    ld a,(de)
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    jp epi

.ret0
    ; exact cancel → +0 (match Z80 m32_fsnormalize normzero)
    ld de,0
    ld hl,0

.epi
    ; DEHL = result; discard X(6)+Y(6)+flag(2)=14 bytes; callee also drops left
    push de
    push hl
    ld de,sp+16
    ld a,(de)                       ; flag
    pop hl
    pop de
    ld c,a
    pop af                          ; X
    pop af
    pop af
    pop af                          ; Y
    pop af
    pop af
    pop af                          ; flag
    ld a,c
    or a
    jp Z,done
    pop bc                          ; ret
    pop af                          ; left L/H
    pop af                          ; left E/D
    push bc
.done
    ret


;------------------------------------------------------------------------------
; unpack DEHL → push 6-byte slot (ret under slot restored)

.unpack_push
    call unpack_dehl
    ld a,l                          ; mant MSB
    pop hl                          ; return address
    push bc                         ; exp, sign
    push de                         ; lsb, mid
    ld b,h
    ld c,l
    ld l,a
    ld h,0
    push hl                         ; msb, 0
    push bc                         ; ret
    ret


.unpack_dehl
    ex de,hl                        ; HLDE = IEEE
    ld a,h
    ld b,a                          ; B = sign (bit7) + exp hi
    add hl,hl                       ; exp → H, mant high → L
    ld c,h                          ; C = exp
    ld a,h
    or a
    jp Z,un0                        ; no hidden bit if exp==0
    scf
.un0
    ld a,l
    rra                             ; rotate in hidden bit
    ld l,a
    ld h,0
    ret                             ; L=msb H=0 DE=mid/lsb B=sign C=exp


.swap6
    ; swap X(+0..5) with Y(+6..11); called so ret is on stack
    pop hl
    ld (swap_ret),hl
    pop hl
    ld (swap_x0),hl
    pop hl
    ld (swap_x1),hl
    pop hl
    ld (swap_x2),hl
    pop hl
    ld (swap_y0),hl
    pop hl
    ld (swap_y1),hl
    pop hl
    ld (swap_y2),hl
    ld hl,(swap_x2)
    push hl
    ld hl,(swap_x1)
    push hl
    ld hl,(swap_x0)
    push hl
    ld hl,(swap_y2)
    push hl
    ld hl,(swap_y1)
    push hl
    ld hl,(swap_y0)
    push hl
    ld hl,(swap_ret)
    push hl
    ret


; Align Y mant right by A shifts.
; On entry A=count; after CALL: ret, X(6), Y(6)
; Y: +8 MSB, +9 pad, +10 LSB, +11 mid

.align_y
    or a
    ret Z
    ld b,a
.aylp
    push bc
    ; after push bc: Y at +10
    ld de,sp+10
    ld a,(de)
    ld l,a                          ; MSB
    inc de
    inc de
    ld a,(de)
    ld c,a                          ; LSB
    inc de
    ld a,(de)
    ld h,a                          ; mid
    ld a,c
    and 01h
    ld b,a                          ; sticky bit shifted out
    ld a,l
    or a
    rra
    ld l,a
    ld a,h
    rra
    ld h,a
    ld a,c
    rra
    or b
    ld c,a
    ld de,sp+10
    ld a,l
    ld (de),a
    inc de
    inc de
    ld a,c
    ld (de),a
    inc de
    ld a,h
    ld (de),a
    pop bc
    dec b
    jp NZ,aylp
    ret


; After CALL into these helpers: ret at +0, X at +2, Y at +8
; X: +2 MSB, +3 pad, +4 LSB, +5 mid, +6 exp, +7 sign
; Y: +8 MSB, +9 pad, +10 LSB, +11 mid, +12 exp, +13 sign

.mant_add
    ld de,sp+4
    ld a,(de)
    ld de,sp+10
    push af
    ld a,(de)
    ld h,a
    pop af
    add a,h
    ld de,sp+4
    ld (de),a
    ld de,sp+5
    ld a,(de)
    ld de,sp+11
    push af
    ld a,(de)
    ld h,a
    pop af
    adc a,h
    ld de,sp+5
    ld (de),a
    ld de,sp+2
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    adc a,h
    ld de,sp+2
    ld (de),a
    ld a,0
    rla
    ret


.mant_sub
    ld de,sp+2
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    jp C,ms_rev
    jp NZ,ms_do
    ld de,sp+5
    ld a,(de)
    ld de,sp+11
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    jp C,ms_rev
    jp NZ,ms_do
    ld de,sp+4
    ld a,(de)
    ld de,sp+10
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    jp C,ms_rev
.ms_do
    ld de,sp+4
    ld a,(de)
    ld de,sp+10
    push af
    ld a,(de)
    ld h,a
    pop af
    sub h
    ld de,sp+4
    ld (de),a
    ld de,sp+5
    ld a,(de)
    ld de,sp+11
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+5
    ld (de),a
    ld de,sp+2
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+2
    ld (de),a
    ret
.ms_rev
    ld de,sp+10
    ld a,(de)
    ld de,sp+4
    push af
    ld a,(de)
    ld h,a
    pop af
    sub h
    ld de,sp+4
    ld (de),a
    ld de,sp+11
    ld a,(de)
    ld de,sp+5
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+5
    ld (de),a
    ld de,sp+8
    ld a,(de)
    ld de,sp+2
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+2
    ld (de),a
    ld de,sp+7
    ld a,(de)
    xor 080h
    ld (de),a
    ret


.mant_zero
    ld de,sp+2
    ld a,(de)
    ld h,a
    ld de,sp+4
    ld a,(de)
    or h
    ld h,a
    ld de,sp+5
    ld a,(de)
    or h
    ret


.mant_shr1
    ld de,sp+4
    ld a,(de)
    and 01h
    ld h,a
    ld de,sp+2
    ld a,(de)
    or a
    rra
    ld (de),a
    ld de,sp+5
    ld a,(de)
    rra
    ld (de),a
    ld de,sp+4
    ld a,(de)
    rra
    or h
    ld (de),a
    ret


; Load X into B=sign, C=exp, H=0, L=MSB, D=mid, E=LSB
; On entry SP: ret, X(6), ...

.load_x_regs
    ld de,sp+7
    ld a,(de)
    ld b,a                          ; sign
    ld de,sp+6
    ld a,(de)
    ld c,a                          ; exp
    ld de,sp+2
    ld a,(de)
    ld l,a                          ; MSB
    ld de,sp+5
    ld a,(de)
    push af                         ; mid on stack
    ld de,sp+6                      ; after push: LSB was +4 → +6
    ld a,(de)
    ld e,a
    pop af
    ld d,a
    ld h,0
    ret


.load_ieee
    push de
    pop hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,b
    ld l,c
    ret


SECTION bss_fp_math32
swap_ret: defs 2
swap_x0:  defs 2
swap_x1:  defs 2
swap_x2:  defs 2
swap_y0:  defs 2
swap_y1:  defs 2
swap_y2:  defs 2
