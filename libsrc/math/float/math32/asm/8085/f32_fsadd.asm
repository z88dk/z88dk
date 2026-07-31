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
;  +12   drop_flag (2)
;  +14   ret (2)
;  +16   left IEEE if callee (4)
;
; X is kept as the larger-or-equal exponent operand.
;
; Rounding: Digi jam-sticky (match z80 d32_fsadd). Lost bits from align
; or sum>>1 OR into the mant LSB. Pack has no residual RNE.
; Sub + normalize: packs as-is via m32_fsnormalize.
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

    call unpack_push                ; Y from DEHL
    ; +0 Y +6 flag +8 ret +10 left
    ld de,sp+10
    call load_ieee
    call unpack_push                ; X
    ; +0 X +6 Y +12 flag +14 ret +16 left

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


; Pack X → IEEE DEHL (jam already in mant LSB)
; SP: ret, X(6), Y(6), flag(2), ...
.pack_x_rne
    ; Digi jam: residual already in mant LSB; pack only
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
    ; discard X(6)+Y(6)+flag(2)=14 bytes
    push de
    push hl
    ld de,sp+16                     ; flag at +12 after X/Y; +4 for pushes → +16
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
    ; Implicit 1: CF=(exp!=0). 255+exp carries iff exp!=0 (subnormals/zero keep CF=0).
    ld a,255
    add a,h
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


; Align Y by A right shifts; jam sticky into Y mant LSB if bits lost.
; SP: ret, X(6), Y(6), flag(2), ...

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
    or a
    jp Z,ay16_njam
    ld de,sp+10                     ; Y.E (SP: ret, X, Y)
    ld a,(de)
    or 1
    ld (de),a
.ay16_njam
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
    or a
    jp Z,ay8_njam
    ld de,sp+10                     ; Y.E
    ld a,(de)
    or 1
    ld (de),a
.ay8_njam
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
    ; after push: Y at +10
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
    or a
    jp Z,ay_njam
    ld de,sp+12                     ; Y.E (SP: bc, ret, X, Y)
    ld a,(de)
    or 1
    ld (de),a
.ay_njam
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


; After CALL: ret, X(6), Y(6), flag(2)
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
    ; SP: ret, X, Y, flag — jam bit out into X.E after >>1
    ld de,sp+4
    ld a,(de)
    and 01h
    ld c,a                          ; C = bit out
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
    ld a,c
    or a
    ret Z
    ld de,sp+4
    ld a,(de)
    or 1
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
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)                   ; last byte: no post-inc (HL → bc next)
    ld hl,bc
    ret
