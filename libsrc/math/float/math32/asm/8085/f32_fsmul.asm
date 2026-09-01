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

    ; ---- specials gate ----
    ; Frame after unpack: x@0 (exp@1, mant@2/4/5), y@6 (exp@7, mant@8/10/11),
    ; sign xor @6 overwrites y sign byte used as result sign.
    ;   0 × finite → ±0     Inf × 0 → NaN     NaN × * → NaN
    ;   Inf × finite → ±Inf  Inf × Inf → ±Inf
    ld de,sp+7
    ld a,(de)                       ; y.exp
    inc a
    jp Z,fm_spec_y                  ; y.exp == 255
    dec a
    or a
    jp Z,fm_spec_y0                 ; y.exp == 0
    ld de,sp+1
    ld a,(de)                       ; x.exp
    inc a
    jp Z,fm_spec_x                  ; x.exp == 255, y finite nonzero

    ld de,sp+7
    ld a,(de)
    sub 07fh
    ld c,a                          ; C = y.exp − bias
    ld de,sp+1
    ld a,(de)                       ; A = x.exp
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
    ld de,sp+7
    ld (de),a                       ; store exp sum

    ld de,sp+10
    ld hl,(de)                      ; y.DE
    push hl
    ld de,sp+10                     ; y.HL (shifted after push)
    ld hl,(de)
    push hl
    ld de,sp+6
    ld a,(de)
    ld l,a                          ; x.L (HL is product later — keep L)
    ld de,sp+8
    ld a,(de+)
    ld c,a
    ld a,(de)
    ld d,a
    ld e,c                          ; LDE = x mant

    call m32_mulu_32h_24x24         ; in LDE=x, stack y; out HLDE=high 32

    push de                         ; park product low; HL = product high
    ld de,sp+8
    ld a,(de+)
    ld c,a
    ld a,(de)
    ld b,a
    pop de                          ; BC = sign/exp, HLDE = product
    call pack_product               ; in BC=sign/exp HLDE=prod; out DEHL=IEEE

    ; DEHL=IEEE; stack: es_l LmH LmD es_r RmH RmD flag ret Lh Ld
    ; Flag then bulk-drop 14 (7 words).  Park DEHL in BC/DE (same as fsadd epi).
    push de
    push hl
    ld de,sp+16
    ld a,(de)                   ; flag
    pop hl
    pop de                      ; A=flag DEHL=result

    ; Park lo in BC; DE (hi) stays.  SP adjust via HL; restore lo.
    ld bc,hl
    ld hl,14
    add hl,sp
    ld sp,hl
    ld hl,bc                    ; DEHL restored; A=flag

    or a
    jp Z,fm_done

    ; callee: drop left; DEHL result already in registers
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
    ; IEEE RNE: G=res.7, S=res[6:0] (via add a,a), B=L.0
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
    ; mant overflow → 1.0, exp++ (E=0; pack left-shift discards implicit 1)
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


    ; ---- cold specials ----
    ; Unpacked mant: L[6:0]|E|D nonzero ⇒ NaN (implicit 1 in L.7).

; y.exp == 0
.fm_spec_y0
    ld de,sp+1
    ld a,(de)
    inc a
    jp Z,fm_ret_nan                 ; Inf/NaN × 0
    jp fm_zero                      ; finite × 0 or 0 × 0

; y.exp == 255
.fm_spec_y
    ld de,sp+8
    ld a,(de)
    and 07fh
    ld b,a
    ld de,sp+10
    ld a,(de)
    or b
    ld b,a
    ld de,sp+11
    ld a,(de)
    or b
    jp NZ,fm_ret_nan                ; y NaN
    ld de,sp+1
    ld a,(de)                       ; x.exp
    or a
    jp Z,fm_ret_nan                 ; 0 × Inf
    inc a
    jp NZ,fm_ovl                    ; finite × Inf → ±Inf
    ld de,sp+2
    ld a,(de)
    and 07fh
    ld b,a
    ld de,sp+4
    ld a,(de)
    or b
    ld b,a
    ld de,sp+5
    ld a,(de)
    or b
    jp NZ,fm_ret_nan                ; NaN × Inf
    jp fm_ovl                       ; Inf × Inf

; x.exp == 255, y finite nonzero
.fm_spec_x
    ld de,sp+2
    ld a,(de)
    and 07fh
    ld b,a
    ld de,sp+4
    ld a,(de)
    or b
    ld b,a
    ld de,sp+5
    ld a,(de)
    or b
    jp NZ,fm_ret_nan                ; x NaN
    jp fm_ovl                       ; Inf × finite

.fm_ret_nan
    ld de,sp+12
    ld a,(de)
    ld b,a                          ; B=flag
    ; DEHL free: bulk-drop es_l..flag (14).  No CALL — that would push uret.
    ld hl,14
    add hl,sp
    ld sp,hl
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
    ; C will be sign from es_r; get flag
    ld de,sp+6
    ld a,(de)
    ld c,a
    ld de,sp+12
    ld a,(de)
    ld b,a                          ; B=flag C=sign
    ld hl,14
    add hl,sp
    ld sp,hl
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
    ld b,a                          ; B=flag C=sign
    ld hl,14
    add hl,sp
    ld sp,hl
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
    ld c,h                          ; C = sign byte
    add hl,hl
    scf
    ld a,l
    rra
    ld l,a
    ld b,h
    ret

.load_ieee_dehl
    ex de,hl
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)                   ; last byte: no post-inc (HL → bc next)
    ld hl,bc
    ret
