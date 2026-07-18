;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsdiv / m32_fsinv — Newton–Raphson reciprocal (Z80 algorithm).
; Expanded 32-bit mul/add. Stack only; never AF for ret/data.
;
; R = N/D = N * 1/D
; D' := D / 2^(e+1)   ∈ [0.5, 1)   (stored as −D' IEEE for NR)
; X  := 140/33 + (−64/11 + 256/99 × D') × D'
; X  := X + X × (1 − D' × X)   (×3)
; 1/D packed from X mant + exp(X.exp − oexp + 126)
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul, m32_fsmul_callee
EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd32x32, m32_fsadd24x32
EXTERN m32_fsconst_ninf, m32_fsconst_pinf

PUBLIC m32_fsdiv, m32_fsdiv_callee
PUBLIC m32_fsinv_fastcall
PUBLIC _m32_invf


.m32_fsdiv
    call m32_fsinv_fastcall
    jp m32_fsmul

.m32_fsdiv_callee
    call m32_fsinv_fastcall
    jp m32_fsmul_callee


.divovl
    pop bc                          ; es: B=exp C=sign80
    ld a,c
    or a
    jp NZ,m32_fsconst_ninf
    jp m32_fsconst_pinf


._m32_invf
.m32_fsinv_fastcall
    ; ---- capture original exp/sign; check /0 ----
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

    ; ---- scale to −D' IEEE: exp := 0xBF, mant unchanged ----
    ; DEHL still original IEEE
    ex de,hl                        ; HL = MSW, DE = LSW
    add hl,hl                       ; eject sign; H=oexp L=mant_top<<1|…
    ld h,0bfh                       ; force −D' exponent field
    ld a,l
    or a
    rra                             ; srl L (logical)
    ld l,a
    ex de,hl                        ; DEHL = −D' IEEE

    ; three −D' copies for three NR steps
    push de
    push hl
    push de
    push hl
    push de
    push hl                         ; SP: d1 d2 d3 es

    ; ---- unpack −D' → expanded, force positive for seed ----
    call unpack
    ld c,0                          ; positive D'

    ; ---- seed: X = 140/33 + (−64/11 + 256/99 × D') × D' ----
    push bc
    push de
    push hl                         ; spare D' expanded
    ld de,04087h
    ld hl,0c1f0h
    push de
    push hl                         ; 140/33 IEEE
    ld de,sp+4
    call load_expanded              ; Y = D'
    push bc
    push de
    push hl                         ; D' for mul32x32
    ld de,0c0bah
    ld hl,02e8ch
    push de
    push hl                         ; −64/11 IEEE
    ld de,04025h
    ld hl,07eb5h
    push de
    push hl                         ; 256/99 IEEE
    ld de,sp+8
    call load_expanded              ; Y = D'
    call m32_fsmul24x32             ; 256/99 × D'
    call m32_fsadd24x32             ; −64/11 + …
    call m32_fsmul32x32             ; (…) × D'
    call m32_fsadd24x32             ; 140/33 + …
    pop af
    pop af
    pop af                          ; drop spare D'; SP: d1 d2 d3 es

    ; ---- NR ×3: X := X + X × (1 − D' × X) ----
    call nr_step
    call nr_step
    call nr_step
    ; SP: es ; BCDEHL = X

    ; ---- pack: result_exp = X.exp − oexp + 126; mant from X ----
    push bc
    push de
    push hl                         ; SP: Xhl Xde Xbc es
    ; 0:Xhl 2:Xde 4:Xc 5:Xexp 6:sign80 7:oexp
    ld de,sp+5
    ld a,(de)                       ; X.exp
    ld b,a
    ld de,sp+7
    ld a,(de)                       ; oexp
    ld c,a
    ld a,b
    sub c
    add a,126
    ld b,a                          ; new exp
    ld de,sp+6
    ld a,(de)
    ld c,a                          ; sign80
    pop hl
    pop de
    pop af                          ; drop X.bc
    ; align 32→24: A=residual, EHL=top24
    ld a,l
    ld l,h
    ld h,e
    ld e,d
    or a
    jp Z,pk0
    inc l
    jp NZ,pk0
    inc h
    jp NZ,pk0
    inc e
    jp NZ,pk0
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    inc b
.pk0
    ld a,e
    add a,a                         ; eject hidden 1
    ld e,a
    ld a,c
    add a,a                         ; sign → CF
    ld a,b
    rra                             ; sign|exp[7:1] → A
    ld d,a
    ld a,e
    rra                             ; exp[0]|mant
    ld e,a
    pop af                          ; drop es
    or a
    ret


;-----------------------------------------------------------------------
; NR step. IN: BC DEHL=X; SP: ret, −D'(4), …
; OUT: BC DEHL=X'; −D' removed
; X := X + X × (1 − D' × X)   using −D' IEEE × X
;-----------------------------------------------------------------------
.nr_step
    push bc
    push de
    push hl                         ; X keep
    push bc
    push de
    push hl                         ; X for mul32
    ld de,03f80h
    ld hl,0
    push de
    push hl                         ; 1.0 IEEE
    ; −D' at SP+18 (X6 + X6 + 1.0_4 + ret_2 = 18): words HL @+0, DE @+2
    ; Recreate push de; push hl order (DE word first, then HL).
    ld de,sp+20
    ld hl,(de)                      ; DE word of −D'
    push hl
    ld de,sp+20
    ld hl,(de)                      ; HL word of −D' (shifted +2 after push)
    push hl                         ; −D' IEEE
    ld de,sp+8
    call load_expanded              ; Y = X (under −D' + 1.0)
    call m32_fsmul24x32             ; −D' × X
    call m32_fsadd24x32             ; 1 − D' × X
    call m32_fsmul32x32             ; X × (1 − D' × X)
    call m32_fsadd32x32             ; X + …
    ; SP: ret, −D'
    pop hl                          ; ret
    pop af
    pop af                          ; drop −D'
    push hl
    ret


;-----------------------------------------------------------------------
; unpack IEEE DEHL → B=exp C=sign80 DEHL=mant<<8 (hidden 1)
;-----------------------------------------------------------------------
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


;-----------------------------------------------------------------------
; load expanded from [DE]: hl,de,bc words (hl @ de+0, de @ de+2, bc @ de+4)
; OUT: BC DEHL; DE pointer clobbered
;-----------------------------------------------------------------------
.load_expanded
    push de
    ld hl,(de)
    push hl
    push de
    pop hl
    inc hl
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    pop hl
    pop af
    ret
