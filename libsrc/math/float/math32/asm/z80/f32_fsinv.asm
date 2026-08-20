;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsinv - z80 / z180 / z80n floating point reciprocal (Newton–Raphson)
;-------------------------------------------------------------------------
;
; D' := D / 2^(e+1)   ∈ [0.5, 1)   (stored as −D' IEEE for NR)
; X  := 140/33 + (−64/11 + 256/99 × D') × D'
; X  := X + X × (1 − D' × X)   (×2 refinements)
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd32x32, m32_fsadd24x32
EXTERN m32_fsconst_ninf, m32_fsconst_pinf
EXTERN m32_fsconst_pnan, m32_fsconst_pzero, m32_fsconst_nzero

PUBLIC m32_fsinv_fastcall
PUBLIC _m32_invf


.divovl
    pop af                      ; get sign
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf


._m32_invf
.m32_fsinv_fastcall
    ex de,hl                    ; DEHL → HLDE

    add hl,hl                   ; sign into C
    ld a,h
    push af                     ; save exponent and sign in C

    or a                        ; divide by zero?
    jr Z,divovl
    inc a                       ; exp was 255?
    jr NZ,inv_finite

    ; exp 255: Inf → signed 0, NaN → NaN.  Stack has push af (sign in C).
    pop af                      ; C = sign
    push af                     ; keep sign; OR clobbers CF
    ld a,l                      ; remaining hi mant after add hl,hl
    or d
    or e
    jr NZ,inv_ret_nan
    pop af
    jp C,m32_fsconst_nzero
    jp m32_fsconst_pzero

.inv_ret_nan
    pop af
    jp m32_fsconst_pnan

.inv_finite
    ld h,0bfh                   ; scale to -0.5 ≤ D' < -1.0
    srl l
    ex de,hl                    ; −D' in DEHL

    push de                     ; −D' for D[2]
    push hl
    push de                     ; −D' for D[1]
    push hl

    rl de                       ; full exp into d
    res 7,c                     ; D' positive
    scf
    rr e                        ; implicit bit
    ld b,d
    ld d,e
    ld e,h
    ld h,l
    ld l,0
;-------------------------------;
                                ; X = 140/33 + (−64/11 + 256/99 × D') × D'
    exx
    ld bc,04087h                ; 140/33
    push bc
    ld bc,0c1f0h
    push bc
    exx
    push bc
    push de
    push hl
    exx
    ld bc,0c0bah                ; −64/11
    push bc
    ld bc,02e8ch
    push bc
    ld bc,04025h                ; 256/99
    push bc
    ld bc,07eb5h
    push bc
    exx
    call m32_fsmul24x32
    call m32_fsadd24x32
    call m32_fsmul32x32
    call m32_fsadd24x32

;-------------------------------;
                                ; X := X + X × (1 − D' × X)
    exx
    pop hl
    pop de
    exx
    push bc
    push de
    push hl
    push bc
    push de
    push hl
    exx
    ld bc,03f80h                ; 1.0
    push bc
    ld bc,0
    push bc
    push de
    push hl
    exx
    call m32_fsmul24x32
    call m32_fsadd24x32
    call m32_fsmul32x32
    call m32_fsadd32x32

;-------------------------------;
    exx
    pop hl
    pop de
    exx
    push bc
    push de
    push hl
    push bc
    push de
    push hl
    exx
    ld bc,03f80h
    push bc
    ld bc,0
    push bc
    push de
    push hl
    exx
    call m32_fsmul24x32
    call m32_fsadd24x32
    call m32_fsmul32x32
    call m32_fsadd32x32

;-------------------------------;

    pop af                      ; D exp and sign in C
    rr c
    sub a,07fh
    neg
    add a,07eh
    ld b,a

    ld a,l
    ld l,h
    ld h,e
    ld e,d

    add a,a
    jr NC,fd0
    jr NZ,fd_up
    bit 0,l
    jr Z,fd0
.fd_up
    inc l
    jr NZ,fd0
    inc h
    jr NZ,fd0
    inc e
    jr NZ,fd0
    ld hl,0
    ld e,l
    inc b

.fd0
    sla e
    sla c
    rr b
    rr e
    ld d,b
    ret
