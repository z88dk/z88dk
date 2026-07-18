;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 sqrt / invsqrt — Quake + 3× Newton on expanded 32-bit paths.
; Stack only (no BSS). Same algorithm as Z80 f32_fssqrt.asm.
;
; w[i+1] = w[i] * (3 − w[i]*w[i]*y) / 2
; w[0]   = 0x5f375a86 − (as_int(y) >> 1)
;
; One reserved −y under the frame; each NR step pushes a working copy.
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul, m32_fsmul_callee
EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd24x32
EXTERN m32_fsconst_nnan

PUBLIC m32_fssqrt, m32_fssqrt_fastcall, m32_fsinvsqrt_fastcall
PUBLIC _m32_sqrtf, _m32_invsqrtf


.m32_fssqrt
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc

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
    pop bc
    push de
    push hl
    push bc
    call m32_fsinvsqrt_fastcall
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
    jp Z,sqrt_zero
    ld a,d
    add a,a
    jp C,m32_fsconst_nnan

    ld a,d
    or 080h
    ld d,a
    push de
    push hl                         ; reserved −y

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
    pop af                          ; drop reserved −y

    ; pack expanded → IEEE (positive); feilipu residual round (same as inv)
    ld a,l
    ld l,h
    ld h,e
    ld e,d                          ; A=residual, EHL=top24
    or a
    jp Z,sq0
    inc l
    jp NZ,sq0
    inc h
    jp NZ,sq0
    inc e
    jp NZ,sq0
    or a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    inc b
.sq0
    ld a,e
    add a,a                         ; eject hidden
    ld e,a
    xor a                           ; sign +
    ld a,b
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    or a
    ret


;=======================================================================
; w := w*(3 − w*w*y)/2
; Z80 operand order: w_keep, 3.0, −y, w → mul32, mul24, add24, /2, mul32
; SP: ret, −y_reserved(4), …; BC DEHL = w; reserved −y not consumed
;=======================================================================
.isqrt_nr
    push bc
    push de
    push hl                         ; w_keep
    ld de,04040h
    ld hl,0
    push de
    push hl                         ; 3.0 IEEE
    ; copy reserved −y at SP+12 (3.0_4 + w_6 + ret_2)
    ld de,sp+14
    ld hl,(de)                      ; DE word
    push hl
    ld de,sp+14
    ld hl,(de)                      ; HL word
    push hl                         ; −y IEEE copy
    ld de,sp+8
    call load_expanded              ; Y = w from w_keep
    push bc
    push de
    push hl                         ; w for mul32
    call m32_fsmul32x32             ; w*w
    call m32_fsmul24x32             ; w*w*−y
    call m32_fsadd24x32             ; 3 − w*w*y
    dec b                           ; /2
    call m32_fsmul32x32             ; w_keep * …
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
    push de
    ld hl,(de)
    push hl
    push de
    pop hl
    inc hl
    inc hl
    ld de,(hl+)
    ld bc,(hl+)
    pop hl
    pop af
    ret
