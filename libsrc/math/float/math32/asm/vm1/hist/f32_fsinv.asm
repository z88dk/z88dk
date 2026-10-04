;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; vm1 m32_fsinv — Newton–Raphson reciprocal.
;-------------------------------------------------------------------------
;
; Same control as 8085.  Frame via ld hl,sp+n / ld a,(hl+).

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd32x32, m32_fsadd24x32
EXTERN m32_fsconst_ninf, m32_fsconst_pinf
EXTERN m32_fsconst_pnan, m32_fsconst_pzero, m32_fsconst_nzero

PUBLIC m32_fsinv_fastcall
PUBLIC _m32_invf


.divovl
    pop bc
    ld a,c
    or a
    jp NZ,m32_fsconst_ninf
    jp m32_fsconst_pinf


._m32_invf
.m32_fsinv_fastcall
    ld a,d
    and 080h
    ld c,a
    ld a,e
    add a,a
    ld a,d
    rla
    ld b,a
    push bc
    or a
    jp Z,divovl
    inc a
    jp NZ,inv_finite

    pop bc
    ld a,e
    and 07fh
    or h
    or l
    jp NZ,m32_fsconst_pnan
    ld a,c
    or a
    jp NZ,m32_fsconst_nzero
    jp m32_fsconst_pzero

.inv_finite
    ex de,hl
    add hl,hl
    ld h,0bfh
    ld a,l
    or a
    rra
    ld l,a
    ex de,hl

    push de
    push hl

    call unpack
    ld c,0

    push bc
    push de
    push hl
    ld de,04087h
    ld hl,0c1f0h
    push de
    push hl
    ld hl,4
    add hl,sp
    call load_expanded
    push bc
    push de
    push hl
    ld de,0c0bah
    ld hl,02e8ch
    push de
    push hl
    ld de,04025h
    ld hl,07eb5h
    push de
    push hl
    ld hl,8
    add hl,sp
    call load_expanded
    call m32_fsmul24x32
    call m32_fsadd24x32
    call m32_fsmul32x32
    call m32_fsadd24x32
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp                          ; drop seed parks (result in BCDEHL)

    call nr_step
    call nr_step

    inc sp
    inc sp
    inc sp
    inc sp                          ; drop x (result in BCDEHL)

    push bc
    push de
    push hl
    ld hl,5
    add hl,sp
    ld b,(hl)
    ld hl,7
    add hl,sp
    ld c,(hl)
    ld a,b
    sub c
    add a,126
    ld b,a                          ; packed exp
    ld hl,6
    add hl,sp
    ld c,(hl)                       ; sign
    pop hl
    pop de
    inc sp
    inc sp                          ; drop expanded high (DEHL live, BC=exp/sign)
    ld a,l
    ld l,h
    ld h,e
    ld e,d
    add a,a
    jp NC,pk0
    jp NZ,pk_up
    ld a,l
    and 01h
    jp Z,pk0
.pk_up
    inc l
    jp NZ,pk0
    inc h
    jp NZ,pk0
    inc e
    jp NZ,pk0
    ld h,0
    ld l,h
    ld e,l
    inc b
.pk0
    ld a,e
    add a,a
    ld e,a
    ld a,c
    add a,a
    ld a,b
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    pop bc                          ; drop sign/exp park (was push bc)
    or a
    ret


.nr_step
    push bc
    push de
    push hl
    push bc
    push de
    push hl

    ld b,07fh
    ld c,0
    ld de,08000h
    ld hl,0
    push bc
    push de
    push hl

    ld hl,20
    add hl,sp
    ex de,hl
    ld hl,(de)
    push hl
    ld hl,24
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl
    pop hl
    call unpack
    push bc
    push de
    push hl

    ld hl,12
    add hl,sp
    call load_expanded
    call m32_fsmul32x32
    call m32_fsadd32x32
    call m32_fsmul32x32
    call m32_fsadd32x32
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


; HL → expanded 6-byte (hl,de,bc).  Exit BC DEHL.  Uses A.
.load_expanded
    ld e,(hl+)                      ; *p++
    ld d,(hl+)                      ; *p++
    push de
    ld e,(hl+)                      ; *p++
    ld d,(hl+)                      ; *p++
    ld c,(hl+)                      ; *p++
    ld b,(hl)
    pop hl
    ret
