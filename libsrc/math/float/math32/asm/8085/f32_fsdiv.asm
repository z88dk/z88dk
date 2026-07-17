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
; 24-bit restoring division of mantissas (no expanded-float Newton).
; Slot layout matches f32_fsadd: +0 MSB, +1 pad, +2 LSB, +3 mid, +4 exp, +5 sign
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
    push af                         ; drop flag
    call unpack_push                ; D (divisor) from DEHL
    ld de,sp+10
    call load_ieee
    call unpack_push                ; N (dividend)
    ; +0 N, +6 D, +12 flag, +14 ret
    call div_core
    jp epi


._m32_invf
.m32_fsinv_fastcall
    ; 1.0 / DEHL
    xor a
    push af                         ; flag 0
    call unpack_push                ; D
    ; N = 1.0 unpacked
    ld bc,0x007f                    ; B=sign0 C=exp127
    push bc
    ld de,0
    push de
    ld hl,0x0080
    push hl
    call div_core
    jp epi


;------------------------------------------------------------------------------
; div_core: N at SP+2, D at SP+8 (ret at +0). Result IEEE in DEHL.
; Uses static div_* workspace.

.div_core
    ; sign
    ld de,sp+7
    ld a,(de)
    ld b,a
    ld de,sp+13
    ld a,(de)
    xor b
    and 080h
    ld (div_sign),a

    ; D.exp == 0 → inf
    ld de,sp+12
    ld a,(de)
    or a
    jp Z,div_inf

    ; N.exp == 0 → zero
    ld de,sp+6
    ld a,(de)
    or a
    jp Z,div_zero

    ; exp = N.exp - D.exp + 127
    ld b,a
    ld de,sp+12
    ld a,(de)
    ld c,a
    ld a,b
    sub c
    ld b,a                          ; signed raw diff in B (two's)
    ld a,127
    add a,b
    ; if raw diff negative and add underflows → zero
    ; check: if B positive (N.exp>=D.exp): add 127, overflow→inf
    ; if B negative: add 127, no carry→underflow zero
    ld a,b
    rla
    jp C,exp_was_neg
    ; non-negative diff
    ld a,127
    add a,b
    jp C,div_inf
    or a
    jp Z,div_zero
    ld (div_exp),a
    jp exp_ready
.exp_was_neg
    ld a,127
    add a,b                         ; B negative
    jp NC,div_zero
    ld (div_exp),a
.exp_ready

    ; load mantissas: N → div_n (32-bit, high=0), D → div_d (24-bit)
    ld de,sp+2
    ld a,(de)
    ld (div_n2),a
    ld de,sp+5
    ld a,(de)
    ld (div_n1),a
    ld de,sp+4
    ld a,(de)
    ld (div_n0),a
    xor a
    ld (div_n3),a

    ld de,sp+8
    ld a,(de)
    ld (div_d2),a
    ld de,sp+11
    ld a,(de)
    ld (div_d1),a
    ld de,sp+10
    ld a,(de)
    ld (div_d0),a

    ; if N < D: N <<= 1, exp--
    call n_lt_d
    jp NC,n_ge_d
    call n_shl1
    ld a,(div_exp)
    dec a
    jp Z,div_zero
    ld (div_exp),a
.n_ge_d

    ; 24-bit restoring division → quot in div_q
    xor a
    ld (div_q0),a
    ld (div_q1),a
    ld (div_q2),a
    ld b,24
.dloop
    ; q <<= 1
    ld a,(div_q0)
    add a,a
    ld (div_q0),a
    ld a,(div_q1)
    rla
    ld (div_q1),a
    ld a,(div_q2)
    rla
    ld (div_q2),a
    ; if N >= D: N -= D, q |= 1
    call n_lt_d
    jp C,d_noshift
    call n_sub_d
    ld a,(div_q0)
    or 01h
    ld (div_q0),a
.d_noshift
    ; N <<= 1
    call n_shl1
    dec b
    jp NZ,dloop

    ; sticky: if N remainder nonzero, set lsb
    ld a,(div_n0)
    ld hl,div_n1
    or (hl)
    inc hl
    or (hl)
    inc hl
    or (hl)
    jp Z,pack
    ld a,(div_q0)
    or 01h
    ld (div_q0),a

.pack
    ld a,(div_q2)
    ld l,a
    ld a,(div_q1)
    ld d,a
    ld a,(div_q0)
    ld e,a
    ld a,(div_exp)
    ld c,a
    ld a,(div_sign)
    ld b,a
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


.div_inf
    ld a,(div_sign)
    rla
    jp C,di_n
    call scrub_to_ret
    jp m32_fsconst_pinf
.di_n
    call scrub_to_ret
    jp m32_fsconst_ninf

.div_zero
    ld a,(div_sign)
    rla
    jp C,dz_n
    call scrub_to_ret
    jp m32_fsconst_pzero
.dz_n
    call scrub_to_ret
    jp m32_fsconst_nzero


; scrub stack of N+D+flag and ret to caller's epi-less path via constants
; On entry from div_core via CALL? No — jp to div_inf from div_core which was CALLed.
; Stack: ret_to_fd_start/inv, N, D, flag, ret_user, ...
; div_core was called, so +0 = return into fd_start after call div_core.
; We need to discard that and do full epi.

.scrub_to_ret
    ; pop div_core ret
    pop hl
    ; now same as epi without result
    ld de,sp+12
    ld a,(de)
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
    ret Z
    pop de                          ; user ret
    pop af
    pop af
    push de
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


; N < D ? C if N < D (32-bit N vs 24-bit D, N high byte div_n3)
.n_lt_d
    ld a,(div_n3)
    or a
    ret NZ                          ; N >= 2^24 > D → NC and NZ, not less
    ld a,(div_n2)
    ld hl,div_d2
    cp (hl)
    ret C
    ret NZ
    ld a,(div_n1)
    ld hl,div_d1
    cp (hl)
    ret C
    ret NZ
    ld a,(div_n0)
    ld hl,div_d0
    cp (hl)
    ret

.n_sub_d
    ld a,(div_n0)
    ld hl,div_d0
    sub (hl)
    ld (div_n0),a
    ld a,(div_n1)
    ld hl,div_d1
    sbc a,(hl)
    ld (div_n1),a
    ld a,(div_n2)
    ld hl,div_d2
    sbc a,(hl)
    ld (div_n2),a
    ld a,(div_n3)
    sbc a,0
    ld (div_n3),a
    ret

.n_shl1
    ld a,(div_n0)
    add a,a
    ld (div_n0),a
    ld a,(div_n1)
    rla
    ld (div_n1),a
    ld a,(div_n2)
    rla
    ld (div_n2),a
    ld a,(div_n3)
    rla
    ld (div_n3),a
    ret


SECTION bss_fp_math32
div_sign: defs 1
div_exp:  defs 1
div_n0:   defs 1
div_n1:   defs 1
div_n2:   defs 1
div_n3:   defs 1
div_d0:   defs 1
div_d1:   defs 1
div_d2:   defs 1
div_q0:   defs 1
div_q1:   defs 1
div_q2:   defs 1
