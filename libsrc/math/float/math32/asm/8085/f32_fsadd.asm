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
; Frame after both unpacks (all stack, no BSS scratch):
;   +0   X slot (6)
;   +6   Y slot (6)
;  +12   GS (2): +12 = guard, +13 = sticky
;  +14   drop_flag (2)
;  +16   ret (2)
;  +18   left IEEE if callee (4)
;
; X is kept as the larger-or-equal exponent operand.
;
; Rounding: IEEE RNE on pack paths that do not call m32_fsnormalize.
;   round_up = G && (S || B); 24-bit mant++ with overflow → >>1, exp++.
; Sub + normalize: G/S ignored (normalize packs as-is).
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
    ; Explicit flag word L=0/1 (not push af — F may be 0)
    ; BC free at entry; DEHL = Y preserved
    ld b,0
    ld c,a
    push bc                         ; drop flag
    ld bc,0
    push bc                         ; GS: guard=0, sticky=0

    call unpack_push                ; Y from DEHL
    ; +0 Y +6 GS +8 flag +10 ret +12 left
    ld de,sp+12
    call load_ieee
    call unpack_push                ; X
    ; +0 X +6 Y +12 GS +14 flag +16 ret +18 left

    ; If Y.exp >= X.exp, swap X/Y slots (stack only)
    ld de,sp+4
    ld a,(de)                       ; X.exp
    ld b,a
    ld de,sp+10
    ld a,(de)                       ; Y.exp
    cp b
    call NC,swap6

    ld de,sp+4
    ld a,(de)
    ld b,a
    ld de,sp+10
    ld a,(de)
    ld c,a
    ld a,b
    sub c                           ; expdiff
    cp 24
    jp NC,pack_x

    call align_y

    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+11
    ld a,(de)
    xor b
    and 080h
    jp NZ,do_sub

    call mant_add
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
    call mant_sub
    call mant_zero
    jp Z,ret0
    ld de,sp+0
    ld a,(de)
    rla
    jp NC,do_sub_norm
    call pack_x_rne
    jp epi
.do_sub_norm
    call load_x_regs
    call m32_fsnormalize
    jp epi

.pack_x
    call pack_x_rne
    jp epi


; IEEE RNE then pack X → DEHL
; SP: ret, X(6), Y(6), GS(2), ...
.pack_x_rne
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
    push af                         ; mid
    ld de,sp+6
    ld a,(de)
    ld e,a                          ; LSB
    pop af
    ld d,a
    ld h,0

    ; GS at sp+14; preserve DE (mid/LSB) while reading GS
    push de
    ld de,sp+16                     ; +14 +2 for push
    ld a,(de)                       ; guard
    or a
    jp Z,px_gs0
    inc de
    ld a,(de)                       ; sticky
    or a
    jp NZ,px_gs_up
    pop de
    ld a,e
    and 01h
    jp Z,px_pack
    jp px_up
.px_gs_up
    pop de
    jp px_up
.px_gs0
    pop de
    jp px_pack
.px_up
    inc e
    jp NZ,px_pack
    inc d
    jp NZ,px_pack
    inc l
    jp NZ,px_pack
    ld l,080h
    ld d,0
    ld e,d
    inc c
    jp Z,px_ovf
.px_pack
    ld a,l
    rla
    ld l,a
    ld a,b
    rla
    ld a,c
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ex de,hl
    ret
.px_ovf
    ld a,b
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    ret


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
    ld de,0
    ld hl,0

.epi
    ; discard X(6)+Y(6)+GS(2)+flag(2)=16 bytes
    push de
    push hl
    ld de,sp+18                     ; flag was +14, +4 for pushes → +18
    ld a,(de)
    pop hl
    pop de
    ld c,a
    pop af                          ; X
    pop af
    pop af
    pop af                          ; Y
    pop af
    pop af
    pop af                          ; GS
    pop af                          ; flag
    ld a,c
    or a
    jp Z,done
    pop bc
    pop af
    pop af
    push bc
.done
    ret


;------------------------------------------------------------------------------
.unpack_push
    call unpack_dehl
    ld a,l
    pop hl
    push bc
    push de
    ld bc,hl
    ld l,a
    ld h,0
    push hl
    push bc
    ret


.unpack_dehl
    ex de,hl
    ld a,h
    ld b,a
    add hl,hl
    ld c,h
    ld a,h
    or a
    jp Z,un0
    scf
.un0
    ld a,l
    rra
    ld l,a
    ld h,0
    ret


; Swap X/Y 6-byte slots; stack only (no BSS).
; SP on entry: ret, X(6), Y(6), GS, ...
.swap6
    pop bc                          ; ret
    ld de,sp+0
    push de
    pop hl                          ; HL = &X
    ld de,sp+6                      ; DE = &Y
    push bc                         ; keep ret off to side… need BC free
    ld b,6
.swlp
    ld a,(hl)
    ld c,a
    ld a,(de)
    ld (hl),a
    ld a,c
    ld (de),a
    inc hl
    inc de
    dec b
    jp NZ,swlp
    pop bc
    push bc
    ret


; Align Y by A right shifts; update GS on stack (not mant LSB).
; SP: ret, X(6), Y(6), GS(2), ...
; GS: +14 guard, +15 sticky

.align_y
    or a
    ret Z
    ld b,a

    ld a,b
    cp 16
    jp C,ay_byte8
    sub 16
    ld b,a
    ld de,sp+10
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    or c
    ld c,a                          ; lost mid|lsb
    ld de,sp+14
    ld a,(de)                       ; old guard
    or c
    ld c,a
    inc de
    ld a,(de)                       ; sticky
    or c
    ld (de),a
    dec de
    xor a
    ld (de),a                       ; guard = 0
    ld de,sp+8
    ld a,(de)
    ld l,a
    xor a
    ld (de),a
    inc de
    inc de
    ld a,l
    ld (de),a
    inc de
    xor a
    ld (de),a

.ay_byte8
    ld a,b
    cp 8
    jp C,ay_bits
    sub 8
    ld b,a
    ld de,sp+10
    ld a,(de)
    ld c,a                          ; lost LSB byte
    ld de,sp+14
    ld a,(de)                       ; old guard
    ld l,a
    ld a,c
    or a
    rra                             ; C>>1
    or l
    ld l,a
    inc de
    ld a,(de)
    or l
    ld (de),a                       ; sticky
    dec de
    ld a,c
    and 01h
    ld (de),a                       ; guard = lost&1
    ld de,sp+10
    inc de
    ld a,(de)
    ld l,a
    ld de,sp+8
    ld a,(de)
    ld h,a
    xor a
    ld (de),a
    inc de
    inc de
    ld a,l
    ld (de),a
    inc de
    ld a,h
    ld (de),a

.ay_bits
    ld a,b
    or a
    ret Z
.aylp
    push bc
    ; after push: Y at +10, GS at +16
    ld de,sp+10
    ld a,(de)
    ld l,a
    inc de
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld h,a
    ld a,c
    and 01h
    ld b,a                          ; bit out
    ld de,sp+16
    ld a,(de)                       ; guard
    ld de,sp+17
    push hl
    ld h,a
    ld a,(de)
    or h                            ; sticky |= guard
    ld (de),a
    dec de
    ld a,b
    ld (de),a                       ; guard = bit out
    pop hl
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


; After CALL: ret, X(6), Y(6), GS(2)
; X: +2 MSB … +7 sign; Y: +8 …

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
    ; SP: ret, X, Y, GS — GS at +14
    ld de,sp+4
    ld a,(de)
    and 01h
    ld c,a                          ; C = bit out
    ld de,sp+14
    ld a,(de)
    ld b,a                          ; B = old guard
    ld de,sp+15
    ld a,(de)
    or b                            ; sticky |= guard
    ld (de),a
    ld de,sp+14
    ld a,c
    ld (de),a                       ; guard = bit out
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
    ld (de),a
    ret


.load_x_regs
    ld de,sp+7
    ld a,(de)
    ld b,a
    ld de,sp+6
    ld a,(de)
    ld c,a
    ld de,sp+2
    ld a,(de)
    ld l,a
    ld de,sp+5
    ld a,(de)
    push af
    ld de,sp+6
    ld a,(de)
    ld e,a
    pop af
    ld d,a
    ld h,0
    ret


.load_ieee
    push de
    pop hl
    ld bc,(hl+)
    ld de,(hl+)
    ld hl,bc
    ret
