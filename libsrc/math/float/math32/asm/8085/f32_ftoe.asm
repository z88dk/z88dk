;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; ftoe — classic %e text via the stack-only dtoa engine
;-------------------------------------------------------------------------
;
; void ftoe(double x, int prec, char *str)  (sccz80 smallc)

SECTION code_clib
SECTION code_fp_math32

PUBLIC ftoe
PUBLIC _ftoe
PUBLIC m32__dtoa_e_core
PUBLIC m32__dtoe_join

EXTERN m32__dtoa_prune
EXTERN m32__dtoa_g_strip
EXTERN m32__dtoa_finish
EXTERN m32__dtoa_putc
EXTERN m32__dtoa_getdst
EXTERN m32_fpclassify
EXTERN m32__dtoa_sgnabs
EXTERN m32__dtoa_base10
EXTERN m32__dtoa_digits
EXTERN m32__dtoa_round
EXTERN m32__dtoa_special


.ftoe
._ftoe
    ld hl,2
    add hl,sp
    ld c,(hl+)
    ld b,(hl)
    push bc
    ld hl,6
    add hl,sp
    ld a,(hl)
    ld hl,8
    add hl,sp
    ld c,(hl+)
    ld b,(hl+)                      ; *p++
    ld e,(hl+)                      ; *p++
    ld d,(hl)
    ld hl,bc
    ld b,0
    call m32__dtoa_e_core
    ret


.m32__dtoa_e_core
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
    jp Z,e_abs_ok
    push de
    push hl
    ld hl,4
    add hl,sp
    ld a,(hl)
    or 080h
    ld (hl),a
    pop hl
    pop de

.e_abs_ok
    call m32_fpclassify
    or a
    jp Z,e_normal

    ld hl,6

    add hl,sp
    call m32__dtoa_special
    jp C,e_spec
    ld hl,4
    add hl,sp
    ld a,(hl)
    ld hl,3
    add hl,sp
    ld (hl),a
    jp m32__dtoa_prune

.e_spec
    ld bc,hl
    ld hl,30
    add hl,sp
    ld (hl+),c
    ld (hl),b
    scf
    jp m32__dtoa_finish

.e_normal
    call m32__dtoa_base10

.m32__dtoe_join
    ; dehl = mantissa, b = e, c = sig
    ; Park e at work+26.  Two pushes: work at SP+4, so work+26 = SP+30.
    push de
    push hl
    ld hl,30
    add hl,sp
    ld (hl),b
    pop hl
    pop de

    ld b,1
    call m32__dtoa_digits           ; one integer digit

    ld a,'.'
    call m32__dtoa_putc

    push de
    push hl
    ld hl,8
    add hl,sp
    ld b,(hl)
    inc b
    pop hl
    pop de
    call m32__dtoa_digits
    jp C,e_round

    dec b
    ld a,b
    ld hl,3
    add hl,sp
    ld (hl),a
    jp e_exp

.e_round
    call m32__dtoa_getdst
    call m32__dtoa_round            ; HL at extra rounding digit
    ld bc,hl

    ld hl,5

    add hl,sp
    ld a,(hl)                       ; carry slot
    cp '0'
    jp Z,e_round_ok

    ; 9.99.. rounded to 10.0 → carry '1', then '.'
    inc hl
    ld a,(hl+)                      ; old first digit
    ld (hl-),a                      ; overwrite '.'
    ld (hl),'.'
    ld hl,26
    add hl,sp
    inc (hl)                        ; e++
    dec bc                          ; drop extra digit

.e_round_ok
    ld hl,30
    add hl,sp
    ld (hl+),c
    ld (hl),b

.e_exp
    ; %g strips fraction zeros before the exponent is written
    ld hl,0
    add hl,sp
    ld a,(hl)
    and 002h
    call NZ,m32__dtoa_g_strip

    ld a,'E'
    call m32__dtoa_putc

    ld hl,26

    add hl,sp
    ld a,(hl)                       ; e
    or a
    ld b,'+'
    jp P,e_plus
    ld b,'-'
    neg

.e_plus
    ld c,a                          ; |e|
    ld a,b
    call m32__dtoa_putc

    ld a,c
    cp 100
    jp C,e_skip100
    sub 100
    ld c,a
    ld a,'1'
    call m32__dtoa_putc
    ld a,c

.e_skip100
    ld b,0                          ; tens
.e_tens
    inc b
    sub 10
    jp NC,e_tens
    add a,10
    dec b
    ld c,a                          ; ones
    ld a,b
    add a,'0'
    call m32__dtoa_putc
    ld a,c
    add a,'0'
    call m32__dtoa_putc
    xor a                           ; NC: not special
    jp m32__dtoa_finish
