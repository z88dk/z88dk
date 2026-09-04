;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsadd / m32_fssub - 8080 IEEE single add/sub
;-------------------------------------------------------------------------
;
; Y lives in registers after unpack:
;   B = sign byte (bit 7), C = exp, LDE = 24-bit mant (H = 0)
;
; X is one 6-byte stack slot:
;   +0 L = mant MSB (hidden 1 if exp!=0)
;   +1     0
;   +2 E = mant LSB
;   +3 D = mant mid
;   +4     exp
;   +5     sign (bit 7)
;
; After prologue (Y park left in place; dropped in epi):
;   +0   X slot (6)
;   +6   Y park (6)
;  +12   drop_flag (2)
;  +14   ret (2)
;  +16   left IEEE if callee (4)
;
; Y is the larger-or-equal exponent operand.  Equal exponents do not swap.
;
; Rounding: Digi jam-sticky.  Lost bits from align or sum>>1 OR into
; the mant LSB after the shift.  Pack has no residual RNE.
;
; 8080: HL as frame pointer (ld hl,sp+n).  Park Y.HL first — L is the
; live mantissa MSB.  ld hl,sp+n clobbers C; save it around adc/sbc.
; No ld de,sp+*, ld hl,(de), ld (de),hl, sub hl,bc, or rl de.

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize
EXTERN m32_fsconst_pnan

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
    ld b,0
    ld c,a
    push bc                         ; drop flag

    call unpack_regs                ; in DEHL=IEEE; out B=sign C=exp LDE=mant

    push bc
    push de
    push hl                         ; park Y
    ld hl,sp+10                     ; HL = &left IEEE
    call load_ieee                  ; DEHL = packed X
    call unpack_push                ; X slot on top; Y still parked
    ; +0 X(6) +6 Y.hl +8 Y.de +10 Y.bc +12 flag +14 ret +16 IEEE

    ld hl,sp+10
    ld c,(hl+)
    ld b,(hl)                       ; Y.bc
    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)
    push de                         ; Y.hl
    ld hl,sp+10                     ; Y.de at +8 +2
    ld e,(hl+)
    ld d,(hl)
    pop hl                          ; Y.hl
    ld h,0
    ; SP: X(6) Y(6) flag ret IEEE; Y in B,C,LDE

    ; ---- specials (exp == 255).  Zeros stay on the add path. ----
    ld a,c
    inc a
    jp Z,fa_spec_y
    push hl                         ; Y.MSB lives in L; DE stays
    ld hl,sp+6                      ; X.exp at +4 +2
    ld a,(hl)
    pop hl
    cp 255
    jp Z,fa_spec_x
    cp c
    jp Z,fa_ops                     ; equal: no swap, no align
    jp C,fa_y_gt                    ; X.exp < Y.exp

    sub c                           ; expdiff = X.exp - Y.exp
    call fa_swap                    ; in A=expdiff; Y↔X slot; A kept
    jp fa_align

.fa_y_gt
    ; A = X.exp, C = Y.exp (A unchanged by cp)
    cpl
    inc a
    add a,c                         ; expdiff = Y.exp - X.exp

.fa_align
    cp 24
    jp NC,fa_pack                   ; small cannot affect Y
    call fa_align_x                 ; in A=expdiff; X slot >>= A, jam sticky

.fa_ops
    push hl                         ; Y.MSB lives in L; DE stays
    ld hl,sp+7                      ; X.sign at +5 +2
    ld a,(hl)
    pop hl
    xor b
    and 080h
    jp NZ,fa_sub

    call fa_addx                    ; in Y=LDE, X slot; out LDE=sum, A=bit24
    or a
    jp Z,fa_pack
    call fa_shr1                    ; in LDE, A=1; out LDE>>=1 with hidden 1
    inc c
    ld a,c
    inc a                           ; new exp == 255 (was 254)
    jp Z,fa_ovf
    jp fa_pack

.fa_sub
    call fa_subx                    ; in Y=LDE, X slot; out LDE=diff, CF=borrow
    jp C,fa_sub_rev                 ; borrow only if expdiff==0
.fa_sub_mag
    call fa_mant_zero
    jp Z,fa_ret0
    ld a,l
    rla
    jp NC,fa_sub_norm
    jp fa_pack

.fa_sub_rev
    call fa_neg24
    ld a,b
    xor 080h
    ld b,a
    jp fa_sub_mag

.fa_sub_norm
    call m32_fsnormalize
    jp fa_epi

.fa_pack
    call fa_pack_regs
    jp fa_epi


; Pack Y (B,C,LDE) → IEEE DEHL.  Through A only.
.fa_pack_regs
    ld a,l
    ex de,hl                        ; HL = mid:lsb
    add a,a                         ; drop hidden 1
    ld e,a
    ld a,b
    add a,a                         ; sign → C
    ld a,c
    rra                             ; sign|exp
    ld d,a
    ld a,e
    rra
    ld e,a
    ret


.fa_ovf
    ld a,b
    call fa_mk_inf
    scf
    jp fa_epi

.fa_ret0
    ld de,0
    ld hl,0
    jp fa_epi


; X.exp == 255.  Y finite (already checked).
.fa_spec_x
    ld hl,sp+0
    ld a,(hl)                       ; MSB
    and 07fh
    inc hl
    inc hl                          ; LSB
    or (hl)
    inc hl                          ; mid
    or (hl)
    jp NZ,fa_ret_nan                ; X NaN
    ld hl,sp+5                      ; sign
    ld a,(hl)
    jp fa_ret_inf

; Y.exp == 255
.fa_spec_y
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,fa_ret_nan                ; Y NaN
    ld hl,sp+4                      ; X.exp
    ld a,(hl)
    inc a
    jp NZ,fa_ret_inf_y              ; Inf ± finite
    ld hl,sp+0
    ld a,(hl)
    and 07fh
    inc hl
    inc hl
    or (hl)
    inc hl
    or (hl)
    jp NZ,fa_ret_nan                ; X NaN
    ld hl,sp+5                      ; X.sign
    ld a,(hl)
    xor b
    and 080h
    jp NZ,fa_ret_nan                ; Inf − Inf
.fa_ret_inf_y
    ld a,b
.fa_ret_inf
    call fa_mk_inf
    jp fa_epi

.fa_ret_nan
    call m32_fsconst_pnan
    jp fa_epi


.fa_epi
    ; DEHL = result.  SP: X(6) Y(6) flag ret IEEE.
    ld bc,hl                        ; park result low
    ld hl,12
    add hl,sp
    ld sp,hl                        ; drop X + Y park
    ld hl,bc                        ; DEHL = result
    pop bc                          ; drop flag
    ld a,c
    or a
    jp Z,fa_done
    pop bc                          ; ret
    pop af
    pop af                          ; drop IEEE X
    push bc
.fa_done
    ret


;------------------------------------------------------------------------------
.unpack_regs
    ld b,d                          ; sign byte
    ex de,hl
    add hl,hl
    ld c,h                          ; exp
    ld a,255
    add a,h                         ; CF = (exp!=0)
    ld a,l
    rra
    ld l,a
    ld h,0                          ; LDE = mant
    ret


.unpack_push
    call unpack_regs
    ld a,l
    pop hl                          ; ret
    push bc
    push de
    ld bc,hl
    ld l,a
    ld h,0
    push hl
    push bc
    ret


.load_ieee
    ; HL = pointer to IEEE float
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc
    ret


;------------------------------------------------------------------------------
; Swap Y (regs) with X (slot).  A = expdiff, preserved.
; CALL: SP = ret, X(6), Y park, flag, ...
; Slot words: (MSB,0), (LSB,mid), (exp,sign)
;------------------------------------------------------------------------------
.fa_swap
    push af
    push bc
    push de
    push hl                         ; Y
    ; +0 Y.hl +2 Y.de +4 Y.bc +6 af +8 ret +10 X

    ld hl,sp+14
    ld c,(hl+)
    ld b,(hl)                       ; X.bc
    ld hl,sp+10
    ld a,(hl)                       ; X.MSB
    push af
    ld hl,sp+14                     ; X.LSB:mid at +12 +2
    ld e,(hl+)
    ld d,(hl)
    pop af
    ld l,a
    ld h,0                          ; X in B,C,LDE

    push de
    push hl                         ; park X.mant; BC stays
    ; +0 X.hl +2 X.de +4 Y.hl +6 Y.de +8 Y.bc +10 af +12 ret +14 X

    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+14
    ld (hl+),e
    ld (hl),d                       ; X.MSB := Y.hl

    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+16
    ld (hl+),e
    ld (hl),d                       ; X.LSB:mid

    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)
    ld hl,sp+18
    ld (hl+),e
    ld (hl),d                       ; X.exp:sign

    pop hl
    pop de                          ; X.mant; BC = X.bc
    pop af
    pop af
    pop af                          ; drop Y park
    pop af                          ; expdiff
    ret


;------------------------------------------------------------------------------
; Align X slot right by A bits.  Jam AFTER the shift into the new LSB.
; CALL: SP = ret, X(6), Y park, flag, ...
;------------------------------------------------------------------------------
.fa_align_x
    push bc
    push de
    push hl                         ; park Y
    ld b,a                          ; count
    ; +0 Y.hl +2 Y.de +4 Y.bc +6 ret +8 X.MSB ...

    ld hl,sp+10
    ld c,(hl+)                      ; LSB
    ld e,(hl)                       ; E = mid (Y parked)
    ld hl,sp+8
    ld l,(hl)                       ; L = MSB
    ld h,e                          ; H = mid, C = LSB

    ld a,b
    cp 16
    jp C,ay8
    sub 16
    ld b,a
    ld a,c
    or h                            ; lost LSB|mid
    ld c,l                          ; new LSB = old MSB
    ld l,0
    ld h,0
    jp Z,ay8
    ld a,c
    or 1
    ld c,a                          ; jam after >>16
.ay8
    ld a,b
    or a
    jp Z,ay_store
    cp 8
    jp C,ayb
    sub 8
    ld b,a
    ld a,c                          ; lost LSB
    ld c,h                          ; new LSB = old mid
    ld h,l                          ; new mid = old MSB
    ld l,0
    or a
    jp Z,ayb
    ld a,c
    or 1
    ld c,a                          ; jam after >>8
.ayb
    ld a,b
    or a
    jp Z,ay_store
.aylp
    ld a,l
    or a
    rra
    ld l,a
    ld a,h
    rra
    ld h,a
    ld a,c
    rra
    ld c,a
    jp NC,ayn
    ld a,c
    or 1
    ld c,a                          ; jam after >>1
.ayn
    dec b
    jp NZ,aylp

.ay_store
    ld a,l                          ; MSB
    ld l,c                          ; L = LSB, H = mid
    ld c,a                          ; C = MSB
    push hl                         ; LSB:mid
    ld l,c
    ld h,0
    ex de,hl                        ; DE = MSB word
    ld hl,sp+10                     ; X.MSB at +8 +2
    ld (hl+),e
    ld (hl),d
    pop de                          ; LSB:mid
    ld hl,sp+10                     ; X.LSB:mid
    ld (hl+),e
    ld (hl),d
    pop hl
    pop de
    pop bc
    ret


;------------------------------------------------------------------------------
; LDE += X.mant.  A = 1 if overflow into bit 24, else 0.
; CALL: SP = ret, X(6), ...
;------------------------------------------------------------------------------
.fa_addx
    ; CALL: +0 ret +2 X.MSB +4 X.LSB:mid
    ; Preload X.MSB so add hl,bc Carry is not lost to ld hl,sp+n.
    push bc                         ; +0 se +2 ret +4 X.MSB +6 X.low
    ld a,l                          ; Y.MSB
    ld bc,de                        ; Y.low
    ld hl,sp+4
    ld d,(hl+)                      ; D = X.MSB
    inc hl                          ; skip pad byte
    ld e,(hl+)
    ld h,(hl)
    ld l,e                          ; HL = X.low
    add hl,bc                       ; C → MSB
    ld e,a                          ; E = Y.MSB
    ld a,d
    adc a,e                         ; MSB sum; C = bit24
    ex de,hl                        ; DE = low sum
    ld l,a
    ld a,0
    rla                             ; A = bit24
    ld h,0
    pop bc
    ret


;------------------------------------------------------------------------------
; LDE -= X.mant.  CF set if borrow.  B,C (sign,exp) preserved.
; CALL: +0 ret +2 X.MSB +4 X.LSB:mid
;------------------------------------------------------------------------------
.fa_subx
    ; CALL: +0 ret +2 X.MSB +4 X.LSB:mid
    ; Preload X so the sbc chain is not split by ld hl,sp+n.
    push bc                         ; +0 se +2 ret +4 X.MSB +6 X.low
    ld a,l                          ; Y.MSB
    ld hl,sp+4
    ld b,(hl+)                      ; B = X.MSB
    inc hl                          ; skip pad byte
    ld c,(hl+)
    ld h,(hl)
    ld l,c                          ; HL = X.low
    ld c,a                          ; C = Y.MSB
    ld a,e
    sub l
    ld l,a
    ld a,d
    sbc a,h
    ld h,a                          ; HL = Y.low − X.low
    ld a,c
    sbc a,b                         ; Y.MSB − X.MSB − borrow
    ex de,hl                        ; DE = low diff
    ld l,a
    ld h,0
    pop bc
    ret


.fa_shr1
    ; add overflow only: inject 1 at the top, jam lost LSB
    scf
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld h,0
    ret NC
    ld a,e
    or 1
    ld e,a
    ret


.fa_neg24
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
    ld a,l
    cpl
    ld l,a
    inc e
    ret NZ
    inc d
    ret NZ
    inc l
    ret


; A[7] = sign.  DEHL = signed IEEE Inf.
.fa_mk_inf
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    ret


.fa_mant_zero
    ld a,l
    or d
    or e
    ret
