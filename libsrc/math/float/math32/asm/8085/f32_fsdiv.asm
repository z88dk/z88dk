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
; X  := X + X × (1 − D' × X)   (×2; seed + residual pack)
; 1/D packed: exp = X.exp − oexp + 126 + feilipu residual round
;
; One reserved −D' under the frame; each NR step pushes a working copy
; (same discipline as invsqrt). B3: expand −D' + push expanded 1.0,
; then mul32/add32 only (no fsmul24x32/fsadd24x32 frame rebuild).
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

    ; ---- scale to −D' IEEE ----
    ex de,hl
    add hl,hl
    ld h,0bfh
    ld a,l
    or a
    rra
    ld l,a
    ex de,hl                        ; DEHL = −D' IEEE

    ; one reserved −D' for all NR steps
    push de
    push hl                         ; SP: −D' es

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
    pop af                          ; drop spare; SP: −D' es

    ; ---- NR ×2 (B1 count; B3 fused step) ----
    call nr_step
    call nr_step
    ; SP: −D' es ; BCDEHL = X

    pop af
    pop af                          ; drop reserved −D'
    ; SP: es

    ; ---- pack: B = X.exp − oexp + 126; residual round ----
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
    ; mant overflow from round: >>1, exp++
    or a                            ; clear CF for logical shifts
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
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    pop af                          ; drop es
    or a
    ret


;-----------------------------------------------------------------------
; B3 fused NR step. IN: BC DEHL=X; SP: ret, −D' IEEE(4), …
; OUT: BC DEHL=X; reserved −D' NOT consumed
;
; Expand −D' and push expanded 1.0, then only mul32/add32.
; Avoids fsmul24x32 / fsadd24x32 frame rebuild.
; Layout after setup: −D'ex | 1.0ex | Xm | Xk | ret | −D'res
;-----------------------------------------------------------------------
.nr_step
    push bc
    push de
    push hl                         ; X keep
    push bc
    push de
    push hl                         ; X for mul32

    ; expanded 1.0: B=0x7F C=0 DEHL=0x80000000
    ld b,07fh
    ld c,0
    ld de,08000h
    ld hl,0
    push bc
    push de
    push hl                         ; 1.0ex

    ; reserved −D' IEEE @ SP+20 (1.0_6 + Xm_6 + Xk_6 + ret_2)
    ld de,sp+20
    ld hl,(de)                      ; −D'.HL
    push hl
    ld de,sp+24
    ld hl,(de)
    ex de,hl
    pop hl                          ; DEHL = −D' IEEE
    call unpack                     ; BCDEHL = expanded −D'
    push bc
    push de
    push hl                         ; −D'ex as mul X

    ld de,sp+12                     ; Xm under −D'ex(6)+1.0(6)
    call load_expanded              ; Y = X
    call m32_fsmul32x32             ; −D' × X  (consumes −D'ex)
    call m32_fsadd32x32             ; 1 − D' × X  (consumes 1.0ex)
    call m32_fsmul32x32             ; X × (1 − D' × X)
    call m32_fsadd32x32             ; X + …
    ; reserved −D' still under ret
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
    push de
    pop hl
    inc hl
    inc hl
    ld de,(hl+)
    ld c,(hl+)
    ld b,(hl+)
    pop hl
    pop af
    ret
