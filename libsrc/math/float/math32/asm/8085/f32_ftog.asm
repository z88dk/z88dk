;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; ftog — classic %g text via the stack-only dtoa engine
;-------------------------------------------------------------------------
;
; void ftog(double x, int prec, char *str)  (sccz80 smallc)
; C99: %e if exponent < -4 or >= precision, else %f; strip trailing zeros.

SECTION code_clib
SECTION code_fp_math32

PUBLIC ftog
PUBLIC _ftog

EXTERN m32__dtoa_e_core
EXTERN m32__dtoa_f_join
EXTERN m32__dtoe_join
EXTERN m32_fpclassify
EXTERN m32__dtoa_sgnabs
EXTERN m32__dtoa_base10
EXTERN m32__dtoa_special
EXTERN m32__dtoa_prune
EXTERN m32__dtoa_finish


.ftog
._ftog
    ld hl,2
    add hl,sp
    ld c,(hl+)
    ld b,(hl)
    push bc
    ld hl,6
    add hl,sp
    ld a,(hl)
    or a
    jp NZ,g_prec
    inc a                           ; prec 0 → 1
.g_prec
    ld hl,8
    add hl,sp
    ld c,(hl+)
    ld b,(hl+)                      ; *p++
    ld e,(hl+)                      ; *p++
    ld d,(hl)
    ld hl,bc
    ld b,002h                       ; flags bit 1 = %g
    call m32__dtoa_g_core
    ret


.m32__dtoa_g_core
    push de
    push hl
    ld c,b
    ld b,a
    push bc
    ld hl,-32
    add hl,sp
    ld sp,hl

    ld hl,32

    add hl,sp
    ld c,(hl+)
    ld b,(hl)
    xor a
    ld hl,0
    add hl,sp
    ld (hl+),c                      ; *p++
    ld (hl+),a                      ; *p++
    ld (hl+),a                      ; *p++
    ld (hl+),a                      ; *p++
    ld (hl+),b                      ; *p++
    ld (hl),'0'

    ld hl,6

    add hl,sp
    ld bc,hl
    ld hl,30
    add hl,sp
    ld (hl+),c
    ld (hl),b

    ld hl,34

    add hl,sp
    ld c,(hl+)
    ld b,(hl+)                      ; *p++
    ld e,(hl+)                      ; *p++
    ld d,(hl)
    ld hl,bc

    call m32__dtoa_sgnabs
    or a
    jp Z,g_abs_ok
    push de
    push hl
    ld hl,4
    add hl,sp
    ld a,(hl)
    or 080h
    ld (hl),a
    pop hl
    pop de

.g_abs_ok
    call m32_fpclassify
    or a
    jp Z,g_normal

    ld hl,6

    add hl,sp
    call m32__dtoa_special
    jp C,g_spec
    ld hl,4
    add hl,sp
    ld a,(hl)
    ld hl,3
    add hl,sp
    ld (hl),a
    jp m32__dtoa_prune

.g_spec
    ld bc,hl
    ld hl,30
    add hl,sp
    ld (hl+),c
    ld (hl),b
    scf
    jp m32__dtoa_finish

.g_normal
    call m32__dtoa_base10           ; B = e, C = sig, DEHL mant

    ld a,b
    cp -4
    jp M,g_style_e

    push de
    push hl
    ld hl,8
    add hl,sp
    cp (hl)                         ; e - prec
    jp P,g_style_e_pop              ; e >= prec

    ; style f: prec -= (e+1)
    ld a,(hl)
    sub b
    dec a
    ld (hl),a
    pop hl
    pop de
    jp m32__dtoa_f_join

.g_style_e_pop
    pop hl
    pop de

.g_style_e
    push de
    push hl
    ld hl,8
    add hl,sp
    dec (hl)                        ; prec--
    pop hl
    pop de
    jp m32__dtoe_join
