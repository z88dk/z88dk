;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fssqr — IEEE single square (always +)
; Rounding: IEEE RNE. Stack only (no BSS).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_pzero, m32_fsconst_pinf, m32_fsconst_pnan
EXTERN m32_sqr_32h_24x24

PUBLIC m32_fssqr, m32_fssqr_fastcall
PUBLIC _m32_sqrf


.m32_fssqr
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc

._m32_sqrf
.m32_fssqr_fastcall
    ; DEHL = y
    ex de,hl                        ; HLDE = IEEE
    add hl,hl                       ; exp→H, ignore sign
    ld a,h
    or a
    jp Z,m32_fsconst_pzero
    ld b,a                          ; B = exp (temp)
    scf
    ld a,l
    rra
    ld l,a                          ; L = mant msb
    ld h,0                          ; HL = msb word for mul frame
    ; DE = mid,lsb already

    ld a,b
    sub 07fh
    jp C,sq_uf
    add a,b
    jp C,m32_fsconst_pinf
    jp sq_ok

.sq_uf
    add a,b
    jp NC,m32_fsconst_pzero

.sq_ok
    or a
    jp Z,m32_fsconst_pzero
    push af                         ; result exp (mul clobbers BC)
    call m32_sqr_32h_24x24          ; HLDE product high 32
    pop bc                          ; B=exp

    ld a,h
    rla
    jp C,sq_normed
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    ld a,l
    rla
    ld l,a
    ld a,h
    rla
    ld h,a
    jp sq_rne
.sq_normed
    inc b
    jp Z,m32_fsconst_pnan
    inc b
    jp Z,m32_fsconst_pinf
    dec b
.sq_rne
    ld a,e
    ld e,h
    ld h,l
    ld l,d
    ld d,a
    and 080h
    jp Z,sq_pack
    ld a,d
    and 07fh
    jp NZ,sq_up
    ld a,l
    and 01h
    jp Z,sq_pack
.sq_up
    inc l
    jp NZ,sq_pack
    inc h
    jp NZ,sq_pack
    inc e
    jp NZ,sq_pack
    ld e,080h
    ld h,0
    ld l,h
    inc b
    jp Z,m32_fsconst_pinf
.sq_pack
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
    ret
