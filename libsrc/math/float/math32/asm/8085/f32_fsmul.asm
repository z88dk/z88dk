;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsmul / m32_fsmul_callee
;
; Rounding: IEEE RNE.  Residual = low 8 of high-32 product (in E after mul).
;   G = residual.7, S = residual[6:0]!=0, B = mant LSB
;   round_up = G && (S || B); then 24-bit mant++ (overflow → >>1, exp++).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_nzero, m32_fsconst_pzero
EXTERN m32_fsconst_ninf, m32_fsconst_pinf, m32_fsconst_pnan
EXTERN m32_mulu_32h_24x24

PUBLIC m32_fsmul, m32_fsmul_callee


.m32_fsmul
    xor a
    jp fm_start

.m32_fsmul_callee
    ld a,1

.fm_start
    ; Explicit flag word L=0/1 (not push af — F may be 0, breaking callee drop)
    ; BC free at entry; DEHL = right float preserved
    ld b,0
    ld c,a
    push bc
    call unpack_dehl
    push de
    push hl
    push bc
    ld de,sp+10
    call load_ieee_dehl
    call unpack_dehl
    push de
    push hl
    push bc

    ld de,sp+0
    ld a,(de)
    ld b,a
    ld de,sp+6
    ld a,(de)
    xor b
    ld de,sp+6
    ld (de),a

    ld de,sp+7
    ld a,(de)
    or a
    jp Z,fm_zero
    sub 07fh
    jp C,fm_uf

    ld c,a
    ld de,sp+1
    ld a,(de)
    or a
    jp Z,fm_zero
    add a,c
    jp C,fm_ovl
    jp fm_exp_done

.fm_uf
    ld c,a
    ld de,sp+1
    ld a,(de)
    or a
    jp Z,fm_zero
    add a,c
    jp NC,fm_zero

.fm_exp_done
    or a
    jp Z,fm_zero
    ld de,sp+7
    ld (de),a

    ld de,sp+10
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    push bc
    ld de,sp+10
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    push bc
    ld de,sp+6
    ld a,(de)
    ld l,a
    ld de,sp+8
    ld a,(de)
    ld c,a
    ld de,sp+9
    ld a,(de)
    ld d,a
    ld e,c

    call m32_mulu_32h_24x24

    push de
    ld de,sp+8
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    pop de
    call pack_product

    ; DEHL=IEEE; stack: es_l LmH LmD es_r RmH RmD flag ret Lh Ld
    push de
    push hl
    ld de,sp+16
    ld a,(de)                   ; flag
    pop hl
    pop de                      ; A=flag DEHL=result
    ld c,a                      ; C=flag (preserve across discards)

    ; discard 7 words (es_l .. flag) -> stack: ret, Lh, Ld
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af

    ld a,c
    or a
    jp Z,fm_done

    ; callee: drop left; preserve DEHL result
    push de
    push hl
    pop hl
    pop de
    pop bc                      ; ret
    pop af                      ; Lh
    pop af                      ; Ld
    push bc                     ; ret only

.fm_done
    ret


.pack_product
    ld a,h
    rla
    jp C,pk_normed
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
    jp pk_round
.pk_normed
    inc b
    jp Z,m32_fsconst_pnan
    inc b
    jp Z,pk_ovl
    dec b
.pk_round
    ; Product HLDE: HLD = top 24, E = residual 8.  Form EHL mant.
    ld a,e                          ; A = residual
    ld e,h
    ld h,l
    ld l,d                          ; EHL = 24-bit mant, A = residual
    ; IEEE RNE: G=res.7, S=res[6:0], B=L.0
    ld d,a                          ; D = residual (E is mant MSB)
    and 080h
    jp Z,pk_pack                    ; G=0
    ld a,d
    and 07fh
    jp NZ,pk_up                     ; G=1 S=1 → up
    ld a,l
    and 01h
    jp Z,pk_pack                    ; tie, already even
.pk_up
    inc l
    jp NZ,pk_pack
    inc h
    jp NZ,pk_pack
    inc e
    jp NZ,pk_pack
    ; mant overflow → 0x800000, exp++
    ld e,080h
    ld h,0
    ld l,h
    inc b
    jp Z,pk_ovl
.pk_pack
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
    ret
.pk_ovl
    ld a,c
    rla
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf


.fm_zero
    ; C will be sign from es_r; get flag
    ld de,sp+6
    ld a,(de)
    ld c,a
    ld de,sp+12
    ld a,(de)
    ld b,a                      ; B=flag C=sign
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    ld a,b
    or a
    jp Z,fm_zret
    pop de
    pop af
    pop af
    push de
.fm_zret
    ld a,c
    rla
    jp C,m32_fsconst_nzero
    jp m32_fsconst_pzero

.fm_ovl
    ld de,sp+6
    ld a,(de)
    ld c,a
    ld de,sp+12
    ld a,(de)
    ld b,a
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    ld a,b
    or a
    jp Z,fm_ovret
    pop de
    pop af
    pop af
    push de
.fm_ovret
    ld a,c
    rla
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf


.unpack_dehl
    ex de,hl
    ld a,h
    ld c,a
    add hl,hl
    scf
    ld a,l
    rra
    ld l,a
    ld b,h
    ret

.load_ieee_dehl
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
