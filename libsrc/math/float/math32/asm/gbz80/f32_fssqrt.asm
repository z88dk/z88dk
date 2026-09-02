;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 sqrt / invsqrt — Quake + 3× Newton on expanded 32-bit paths.
;-------------------------------------------------------------------------
;
; Same algorithm as 8085.  Frame via ld hl,sp+n / ld a,(hl+).

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul, m32_fsmul_callee
EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd24x32
EXTERN m32_fsconst_nnan, m32_fsconst_ninf
EXTERN m32_fsconst_pnan, m32_fsconst_pinf, m32_fsconst_pzero

PUBLIC m32_fssqrt, m32_fssqrt_fastcall, m32_fsinvsqrt_fastcall
PUBLIC _m32_sqrtf, _m32_invsqrtf


.m32_fssqrt
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp m32_fssqrt_fastcall

._m32_sqrtf
.m32_fssqrt_fastcall
    ld a,d
    and 07fh
    ld b,a
    ld a,e
    and 080h
    or b
    jp Z,sqrt_zero
    ld a,d
    add a,a
    jp C,m32_fsconst_nnan
    ld a,e
    add a,a
    ld a,d
    rla
    inc a
    jp NZ,sqrt_finite
    ld a,e
    and 07fh
    or h
    or l
    jp NZ,m32_fsconst_pnan
    jp m32_fsconst_pinf

.sqrt_finite
    pop bc
    push de
    push hl
    push bc
    call m32_fsinvsqrt_body
    jp m32_fsmul_callee


.sqrt_zero
    ld de,0
    ld hl,0
    ret


._m32_invsqrtf
.m32_fsinvsqrt_fastcall
    ld a,d
    and 07fh
    ld b,a
    ld a,e
    and 080h
    or b
    jp NZ,invsqrt_nz
    ld a,d
    add a,a
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf
.invsqrt_nz
    ld a,d
    add a,a
    jp C,m32_fsconst_nnan
    ld a,e
    add a,a
    ld a,d
    rla
    inc a
    jp NZ,m32_fsinvsqrt_body
    ld a,e
    and 07fh
    or h
    or l
    jp NZ,m32_fsconst_pnan
    jp m32_fsconst_pzero

.m32_fsinvsqrt_body

    ld a,d
    or 080h
    ld d,a
    push de
    push hl

    ld a,d
    and 07fh
    ld d,a

    or a
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

    ld a,086h
    sub l
    ld l,a
    ld a,05ah
    sbc a,h
    ld h,a
    ld a,037h
    sbc a,e
    ld e,a
    ld a,05fh
    sbc a,d
    ld d,a

    call unpack
    call isqrt_nr
    call isqrt_nr
    call isqrt_nr

    pop af
    pop af

    ld a,l
    ld l,h
    ld h,e
    ld e,d
    add a,a
    jp NC,sq0
    jp NZ,sq_up
    ld a,l
    and 01h
    jp Z,sq0
.sq_up
    inc l
    jp NZ,sq0
    inc h
    jp NZ,sq0
    inc e
    jp NZ,sq0
    ld h,0
    ld l,h
    ld e,l
    inc b
.sq0
    ld a,e
    add a,a
    ld e,a
    xor a
    ld a,b
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    or a
    ret


.isqrt_nr
    push bc
    push de
    push hl
    ld de,04040h
    ld hl,0
    push de
    push hl
    ld hl,sp+14
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld hl,sp+14
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    push hl
    ld hl,sp+8
    call load_expanded
    push bc
    push de
    push hl
    call m32_fsmul32x32
    call m32_fsmul24x32
    call m32_fsadd24x32
    dec b
    call m32_fsmul32x32
    ret


.unpack
    ld a,d
    and 080h
    ld c,a
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld b,a
    or a
    ld a,e
    jp Z,un0
    scf
.un0
    rra
    ld d,a
    ld e,h
    ld h,l
    ld l,0
    ret


.load_expanded
    ld e,(hl+)
    ld d,(hl+)
    push de
    ld e,(hl+)
    ld d,(hl+)
    ld c,(hl+)
    ld b,(hl)
    pop hl
    ret
