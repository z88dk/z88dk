;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fspoly — Horner via fsmul/fsadd (callee)
; sccz80: SP = ret, n(2), dptr(2), x(4)
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul_callee
EXTERN m32_fsadd_callee

PUBLIC m32_fspoly_callee
PUBLIC _m32_polyf


._m32_polyf
.m32_fspoly_callee
    pop bc                          ; ret
    pop hl                          ; n
    pop de                          ; dptr
    ld a,l
    push de
    push hl
    push bc
    ld b,a

    ld hl,0
    add hl,sp
    ld de,4
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl

    push bc
    ld a,b
    add a,a
    add a,a
    ld e,a
    ld d,0
    add hl,de
    call load_float_hl
    pop bc

.poly_loop
    ld a,b
    or a
    jp Z,poly_done
    dec b
    push bc
    push de
    push hl
    ld de,sp+12
    call load_float_de
    call m32_fsmul_callee
    push de
    push hl
    ld de,sp+10
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    ld de,sp+5
    ld a,(de)
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    call load_float_hl
    call m32_fsadd_callee
    pop bc
    jp poly_loop

.poly_done
    ; DEHL = result; SP = ret, n, dptr, x(4)
    push de
    push hl                         ; SP: r.HL, r.DE, ret, n, dptr, x
    pop hl
    pop de                          ; DEHL = result
    pop bc                          ; BC = ret
    ; SP: n, dptr, x
    inc sp
    inc sp                          ; drop n
    inc sp
    inc sp                          ; drop dptr
    inc sp
    inc sp
    inc sp
    inc sp                          ; drop x
    push bc                         ; ret
    or a
    ret

.load_float_de
    push de
    pop hl
.load_float_hl
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
