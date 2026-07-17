;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 sqrt / invsqrt — Quake + Newton (24-bit mul/add/div2).
; Stack only (no BSS).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul_callee
EXTERN m32_fsadd_callee
EXTERN m32_fsdiv2_fastcall
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
    ; exp==0? (D&0x7f)==0 && (E&0x80)==0; sign in D.7
    ld a,d
    and 07fh
    ld b,a
    ld a,e
    and 080h
    or b
    jp Z,sqrt_zero
    ld a,d
    rla
    jp C,m32_fsconst_nnan
    ; Stack for final mul: ret, y (callee left). Ret must sit under y.
    pop bc                          ; ret
    push de
    push hl                         ; y
    push bc                         ; ret
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
    rla
    jp C,m32_fsconst_nnan

    push de
    push hl
    push de
    push hl
    push de
    push hl                         ; 3 × y

    ; w0 = 0x5f375a86 - (as_be32(DEHL) >> 1); D=MSB
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

    call nr_step
    call nr_step
    call nr_step
    ret


; DEHL=w; SP: ret_nr, y(4).  y removed on exit. DEHL=new w
; Keep ret_nr on the stack (callees clobber BC).
.nr_step
    ; SP: ret, y; DEHL=w
    push de
    push hl                         ; SP: w, ret, y
    push de
    push hl                         ; SP: w, w, ret, y
    call m32_fsmul_callee           ; DEHL=w*w; SP: w, ret, y
    push de
    push hl                         ; SP: ww, w, ret, y
    ; y at SP+10
    ld de,sp+10
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    inc de
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld d,a
    ld e,c                          ; DEHL=y; SP: ww, w, ret, y
    call m32_fsmul_callee           ; DEHL=y*ww; SP: w, ret, y
    ld a,d
    xor 080h
    ld d,a                          ; -yww
    push de
    push hl                         ; SP: -yww, w, ret, y
    ld de,04040h
    ld hl,0                         ; 3.0
    call m32_fsadd_callee           ; DEHL=3-yww; SP: w, ret, y
    call m32_fsdiv2_fastcall        ; /2
    call m32_fsmul_callee           ; DEHL=new w; SP: ret, y
    pop bc                          ; ret_nr
    pop af
    pop af                          ; drop y
    push bc
    ret
