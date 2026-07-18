;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_fsdiv / m32_fsinv - 8085 IEEE single divide / reciprocal
;-------------------------------------------------------------------------
; Stack only (no BSS). Restoring 24-bit div + IEEE RNE.
;
; Setup: +0 N(6) +6 D(6) +12 flag +14 ret [+16 left]
; Slot: +0 msb +1 n3 +2 lsb +3 mid +4 exp +5 sign
;
; With Q work: +0 ret +2 q0 +3 q1 +4 q2 +5 g +6 N +12 D +18 flag
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_ninf, m32_fsconst_pinf
EXTERN m32_fsconst_nzero, m32_fsconst_pzero

PUBLIC m32_fsdiv, m32_fsdiv_callee
PUBLIC m32_fsinv_fastcall
PUBLIC _m32_invf


.m32_fsdiv
    xor a
    jp fd_start

.m32_fsdiv_callee
    ld a,1

.fd_start
    ; Explicit flag word L=0/1 (not push af — F may be 0)
    ; BC free at entry; DEHL = right float preserved
    ld b,0
    ld c,a
    push bc
    call unpack_push
    ld de,sp+10
    call load_ieee
    call unpack_push
    call div_core
    jp epi


._m32_invf
.m32_fsinv_fastcall
    ld bc,0
    push bc                         ; non-callee flag (clean word)
    call unpack_push
    ld bc,0x007f
    push bc
    ld de,0
    push de
    ld hl,0x0080
    push hl
    call div_core
    jp epi


.div_core
    ; SP: ret, N@2, D@8, flag@14
    ld de,sp+7
    ld a,(de)
    ld b,a
    ld de,sp+13
    ld a,(de)
    xor b
    and 080h
    ld de,sp+7
    ld (de),a                       ; result sign

    ld de,sp+12
    ld a,(de)
    or a
    jp Z,div_inf

    ld de,sp+6
    ld a,(de)
    or a
    jp Z,div_zero

    ld b,a
    ld de,sp+12
    ld a,(de)
    ld c,a
    ld a,b
    sub c
    ld b,a
    rla
    jp C,exp_neg
    ld a,127
    add a,b
    jp C,div_inf
    or a
    jp Z,div_zero
    ld de,sp+6
    ld (de),a
    jp exp_ok
.exp_neg
    ld a,127
    add a,b
    jp NC,div_zero
    ld de,sp+6
    ld (de),a
.exp_ok
    ld de,sp+3
    xor a
    ld (de),a                       ; n3=0 (N.pad)

    ; Q work 4 bytes
    pop hl
    ld de,0
    push de
    push de
    push hl
    ; SP: ret, q0,q1, q2,g, N@6, D@12, flag@18

    call cmp_nd
    jp NC,aligned
    call shl_n
    ld de,sp+10
    ld a,(de)
    dec a
    jp Z,zero_dropq
    ld (de),a
.aligned
    ld b,24
.loop
    call shl_q
    call cmp_nd
    jp C,no_sub
    call sub_nd
    ld de,sp+2
    ld a,(de)
    or 01h
    ld (de),a
.no_sub
    call shl_n
    dec b
    jp NZ,loop

    ; guard
    ld de,sp+5
    xor a
    ld (de),a
    call shl_n
    call cmp_nd
    jp C,g_done
    call sub_nd
    ld de,sp+5
    ld a,1
    ld (de),a
.g_done
    ld de,sp+6
    ld a,(de)
    ld h,a
    ld de,sp+7
    ld a,(de)
    or h
    ld h,a
    ld de,sp+8
    ld a,(de)
    or h
    ld h,a
    ld de,sp+9
    ld a,(de)
    or h
    ld c,a                          ; sticky

    ld de,sp+5
    ld a,(de)
    or a
    jp Z,pack
    ld a,c
    or a
    jp NZ,qinc
    ld de,sp+2
    ld a,(de)
    and 01h
    jp Z,pack
.qinc
    ld de,sp+2
    ld a,(de)
    inc a
    ld (de),a
    jp NZ,pack
    inc de
    ld a,(de)
    inc a
    ld (de),a
    jp NZ,pack
    inc de
    ld a,(de)
    inc a
    ld (de),a
    jp NZ,pack
    ld a,080h
    ld (de),a
    dec de
    xor a
    ld (de),a
    dec de
    ld (de),a
    ld de,sp+10
    ld a,(de)
    inc a
    ld (de),a
    jp Z,inf_dropq

.pack
    ; q → N mant; free Q; pack N → DEHL
    ; Q@+2: q0,q1,q2; N@+6: msb,n3,lsb,mid,exp,sign
    ld de,sp+2
    ld a,(de)                       ; q0
    ld de,sp+8
    ld (de),a                       ; N.lsb
    ld de,sp+3
    ld a,(de)                       ; q1
    ld de,sp+9
    ld (de),a                       ; N.mid
    ld de,sp+4
    ld a,(de)                       ; q2
    ld de,sp+6
    ld (de),a                       ; N.msb
    ; free Q (4 bytes under ret)
    pop hl
    pop af
    pop af
    push hl
    ; SP: ret, N, D, flag
    ; N: +2 msb +3 n3 +4 lsb +5 mid +6 exp +7 sign
    ld de,sp+2
    ld a,(de)
    ld l,a                          ; msb
    ld de,sp+4
    ld a,(de)
    ld c,a                          ; lsb
    ld de,sp+5
    ld a,(de)
    ld d,a
    ld e,c                          ; DE = mid,lsb
    push de
    ld de,sp+8                      ; exp (+6+2)
    ld a,(de)
    ld c,a
    ld de,sp+9
    ld a,(de)
    ld b,a                          ; sign
    pop de
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


.inf_dropq
    pop hl
    pop af
    pop af
    push hl
    jp div_inf

.zero_dropq
    pop hl
    pop af
    pop af
    push hl
    jp div_zero


.div_inf
    ld de,sp+7
    ld a,(de)
    rla
    jp C,di_n
    call scrub
    jp m32_fsconst_pinf
.di_n
    call scrub
    jp m32_fsconst_ninf

.div_zero
    ld de,sp+7
    ld a,(de)
    rla
    jp C,dz_n
    call scrub
    jp m32_fsconst_pzero
.dz_n
    call scrub
    jp m32_fsconst_nzero


; Stack at call scrub (from div_zero/div_inf via call):
;   +0 ret_scrub  +2 ret_after_divcore  +4 N(6)  +10 D(6)  +16 flag  +18 ret_C  [+20 left if callee]
; Epi (normal path) sees stack without ret_after_divcore (div_core already returned).
; Scrub must also drop ret_after_divcore + N + D + flag, then callee-drop left,
; and return to div_zero/div_inf with SP → ret_C only.
.scrub
    pop hl                          ; HL = return to div_zero/div_inf
    pop af                          ; drop ret_after_divcore
    pop af                          ; drop N (3 words)
    pop af
    pop af
    pop af                          ; drop D (3 words)
    pop af
    pop af
    pop bc                          ; BC = flag word (C = 0/1)
    ld a,c
    or a
    jp Z,scrub_ret
    pop de                          ; DE = ret_C
    pop af                          ; drop left
    pop af
    push de                         ; ret_C only
.scrub_ret
    push hl                         ; back to div_zero/div_inf
    ret


.epi
    push de
    push hl
    ld de,sp+16
    ld a,(de)
    pop hl
    pop de
    ld c,a
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
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
; Helpers with Q allocated. After CALL:
; +0 ret_h +2 ret_div +4 q0 +5 q1 +6 q2 +7 g +8 N +14 D
; N: +8 msb +9 n3 +10 lsb +11 mid +12 exp +13 sign
; D: +14 msb +15 pad +16 lsb +17 mid

.cmp_nd
    ld de,sp+9
    ld a,(de)
    or a
    ret NZ
    ld de,sp+8
    ld a,(de)
    ld de,sp+14
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    ret C
    ret NZ
    ld de,sp+11
    ld a,(de)
    ld de,sp+17
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    ret C
    ret NZ
    ld de,sp+10
    ld a,(de)
    ld de,sp+16
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    ret


.sub_nd
    ld de,sp+10
    ld a,(de)
    ld de,sp+16
    push af
    ld a,(de)
    ld h,a
    pop af
    sub h
    ld de,sp+10
    ld (de),a
    ld de,sp+11
    ld a,(de)
    ld de,sp+17
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+11
    ld (de),a
    ld de,sp+8
    ld a,(de)
    ld de,sp+14
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+8
    ld (de),a
    ld de,sp+9
    ld a,(de)
    sbc a,0
    ld (de),a
    ret


.shl_n
    ld de,sp+10
    ld a,(de)
    add a,a
    ld (de),a
    ld de,sp+11
    ld a,(de)
    rla
    ld (de),a
    ld de,sp+8
    ld a,(de)
    rla
    ld (de),a
    ld de,sp+9
    ld a,(de)
    rla
    ld (de),a
    ret


.shl_q
    ld de,sp+4
    ld a,(de)
    add a,a
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    ret


.unpack_push
    call unpack_dehl
    ld a,l
    pop hl
    push bc
    push de
    ld b,h
    ld c,l
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
