;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsinv — Newton–Raphson reciprocal (from former f32_fsdiv).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd32x32, m32_fsadd24x32
EXTERN m32_fsconst_ninf, m32_fsconst_pinf
EXTERN m32_fsconst_pnan, m32_fsconst_pzero, m32_fsconst_nzero

PUBLIC m32_fsinv_fastcall
PUBLIC _m32_invf


.divovl
    pop bc                          ; es: B=exp C=sign80
    ld a,c
    or a
    jp NZ,m32_fsconst_ninf
    jp m32_fsconst_pinf


._m32_invf
.m32_fsinv_fastcall
    ld a,d
    and 080h
    ld c,a                          ; sign80
    ld a,e
    add a,a
    ld a,d
    rla
    ld b,a                          ; oexp
    push bc                         ; es
    or a
    jp Z,divovl
    inc a                           ; exp was 255?
    jp NZ,inv_finite

    ; exp 255: Inf → signed 0, NaN → NaN
    pop bc                          ; C = sign80
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
    ex de,hl                        ; DEHL = −D' IEEE

    push de
    push hl                         ; SP: −D' es

    call unpack
    ld c,0                          ; positive D'

    push bc
    push de
    push hl                         ; spare D'
    ld de,04087h
    ld hl,0c1f0h
    push de
    push hl                         ; 140/33
    ld de,sp+4
    call load_expanded
    push bc
    push de
    push hl
    ld de,0c0bah
    ld hl,02e8ch
    push de
    push hl                         ; −64/11
    ld de,04025h
    ld hl,07eb5h
    push de
    push hl                         ; 256/99
    ld de,sp+8
    call load_expanded
    call m32_fsmul24x32
    call m32_fsadd24x32
    call m32_fsmul32x32
    call m32_fsadd24x32
    pop af
    pop af
    pop af

    call nr_step
    call nr_step

    pop af
    pop af                          ; drop −D'

    push bc
    push de
    push hl
    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+7
    ld a,(de)
    ld c,a
    ld a,b
    sub c
    add a,126
    ld b,a
    ld de,sp+6
    ld a,(de)
    ld c,a
    pop hl
    pop de
    pop af
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
    pop af
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

    ld de,sp+20
    ld hl,(de)
    push hl
    ld de,sp+24
    ld hl,(de)
    ex de,hl
    pop hl
    call unpack
    push bc
    push de
    push hl

    ld de,sp+12
    call load_expanded
    ; Y in regs, X on stack — add32 no longer parks Y
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


.load_expanded
    push de
    ld hl,(de)
    push hl
    ex de,hl
    inc hl
    inc hl
    ld de,(hl+)
    ld c,(hl+)
    ld b,(hl)
    pop hl
    pop af
    ret
