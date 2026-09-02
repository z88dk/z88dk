;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 m32_fsmul / m32_fsmul_callee
;-------------------------------------------------------------------------
;
; Rounding: IEEE RNE.  Residual = low 8 of high-32 product (in E after mul).
;   G = residual.7, S = residual[6:0]!=0, B = mant LSB
;   round_up = G && (S || B); then 24-bit mant++ (overflow → >>1, exp++).
;
; Frame access via ld hl,sp+n.  Native ld hl,sp+* / ld a,(hl+). No exx. No cheap ex de,hl.

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
    ld b,0
    ld c,a
    push bc
    call unpack_dehl
    push de
    push hl
    push bc
    ld hl,sp+10
    call load_ieee_dehl
    call unpack_dehl
    push de
    push hl
    push bc

    ld hl,sp+0
    ld b,(hl)                       ; x.sign
    ld hl,sp+6
    ld a,(hl)                       ; y.sign
    xor b
    ld hl,sp+6
    ld (hl),a                       ; result sign at y.sign slot

    ; ---- specials gate ----
    ; Frame: x@0 (exp@1, mant@2/4/5), y@6 (exp@7, mant@8/10/11),
    ; sign xor @6 overwrites y sign byte used as result sign.
    ld hl,sp+7
    ld a,(hl)                       ; y.exp
    inc a
    jp Z,fm_spec_y                  ; y.exp == 255
    dec a
    or a
    jp Z,fm_spec_y0                 ; y.exp == 0
    ld hl,sp+1
    ld a,(hl)                       ; x.exp
    inc a
    jp Z,fm_spec_x                  ; x.exp == 255, y finite nonzero

    ld hl,sp+1
    ld b,(hl)                       ; B = x.exp
    ld hl,sp+7
    ld a,(hl)
    sub 07fh
    ld c,a                          ; C = y.exp − bias (keep sub flags)
    ld a,b                          ; A = x.exp
    jp C,fm_exp_uf

    add a,c                         ; sum of exponents
    jp C,fm_ovl                     ; overflow only if x.exp != 0
    cp c                            ; sum == y.adj ⇒ x.exp == 0
    jp Z,fm_zero
    jp fm_exp_ok

.fm_exp_uf
    add a,c
    jp NC,fm_zero                   ; underflow or x.exp == 0

.fm_exp_ok
    or a
    jp Z,fm_zero
    ld hl,sp+7
    ld (hl),a                       ; store exp sum

    ld hl,sp+10
    ld c,(hl+)
    ld b,(hl)
    push bc                         ; y.DE
    ld hl,sp+10
    ld c,(hl+)
    ld b,(hl)
    push bc                         ; y.HL
    ld hl,sp+6
    ld c,(hl)                       ; x.L (mant high)
    ld hl,sp+8
    ld e,(hl+)
    ld d,(hl)                       ; DE = x.DE
    ld l,c                          ; LDE = x mant

    call m32_mulu_32h_24x24         ; in LDE=x, stack y; out HLDE=high 32

    push de
    push hl                         ; product high lives in HL
    ld hl,sp+10                     ; sign/exp at +6/+7 +4
    ld c,(hl+)
    ld b,(hl)
    pop hl
    pop de                          ; BC = sign/exp, HLDE = product
    call pack_product               ; in BC=sign/exp HLDE=prod; out DEHL=IEEE

    ; DEHL=IEEE; stack: es_l LmH LmD es_r RmH RmD flag ret Lh Ld
    push de
    push hl
    ld hl,sp+16
    ld a,(hl)                   ; flag
    pop hl
    pop de                      ; A=flag DEHL=result

    ld bc,hl
    add sp,14
    ld hl,bc                    ; DEHL restored; A=flag

    or a
    jp Z,fm_done

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
    add a,a
    jp NC,pk_pack                   ; G=0
    jp NZ,pk_up                     ; G=1 S≠0 → up
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
    ld h,0
    ld l,h
    ld e,l
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


; y.exp == 0
.fm_spec_y0
    ld hl,sp+1
    ld a,(hl)
    inc a
    jp Z,fm_ret_nan                 ; Inf/NaN × 0
    jp fm_zero                      ; finite × 0 or 0 × 0

; y.exp == 255
.fm_spec_y
    ld hl,sp+8
    ld a,(hl)
    and 07fh
    ld b,a
    ld hl,sp+10
    ld a,(hl)
    or b
    ld b,a
    ld hl,sp+11
    ld a,(hl)
    or b
    jp NZ,fm_ret_nan                ; y NaN
    ld hl,sp+1
    ld a,(hl)                       ; x.exp
    or a
    jp Z,fm_ret_nan                 ; 0 × Inf
    inc a
    jp NZ,fm_ovl                    ; finite × Inf → ±Inf
    ld hl,sp+2
    ld a,(hl)
    and 07fh
    ld b,a
    ld hl,sp+4
    ld a,(hl)
    or b
    ld b,a
    ld hl,sp+5
    ld a,(hl)
    or b
    jp NZ,fm_ret_nan                ; NaN × Inf
    jp fm_ovl                       ; Inf × Inf

; x.exp == 255, y finite nonzero
.fm_spec_x
    ld hl,sp+2
    ld a,(hl)
    and 07fh
    ld b,a
    ld hl,sp+4
    ld a,(hl)
    or b
    ld b,a
    ld hl,sp+5
    ld a,(hl)
    or b
    jp NZ,fm_ret_nan                ; x NaN
    jp fm_ovl                       ; Inf × finite

.fm_ret_nan
    ld hl,sp+12
    ld b,(hl)                       ; B=flag
    add sp,14
    ld a,b
    or a
    jp Z,fm_nanret
    pop de
    pop af
    pop af
    push de
.fm_nanret
    jp m32_fsconst_pnan

.fm_zero
    ld hl,sp+6
    ld c,(hl)
    ld hl,sp+12
    ld b,(hl)                       ; B=flag C=sign
    add sp,14
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
    ld hl,sp+6
    ld c,(hl)
    ld hl,sp+12
    ld b,(hl)                       ; B=flag C=sign
    add sp,14
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
    push hl
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    ld c,h                          ; C = sign byte
    add hl,hl
    scf
    ld a,l
    rra
    ld l,a
    ld b,h
    ret

.load_ieee_dehl
    ; HL = pointer to IEEE float
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc
    ret
