;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv - z80, z180, z80n floating point divide
;-------------------------------------------------------------------------
; R = N/D = N * 1/D
;
; We calculate division of two floating point number by refining an
; estimate of the reciprocal of y using newton iterations.  Each iteration
; gives us just less than twice previous precision in binary bits (2n-2).
;
; Division is then done by multiplying by the reciprocal of the divisor.
;
;-------------------------------------------------------------------------
; m32_fsinv - z80, z180, z80n floating point inversion (reciprocal)
;-------------------------------------------------------------------------
;
; Computes R the quotient of N and D
;
; Express D as M × 2e where 1 ≤ M < 2 (standard floating point representation)
;
; D' := D / 2e+1   // scale between 0.5 and 1
; N' := N / 2e+1
; X  := 140/33 + (-64/11 + 256/99 x D') x D'
; precompute constants with same precision as D
;
; while
;    X := X + X × (1 - D' × X)
; return N' × X
;
;-------------------------------------------------------------------------

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
    pop af                      ; get sign
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf         ; done overflow


._m32_invf
.m32_fsinv_fastcall
    ex de,hl                    ; DEHL -> HLDE

    add hl,hl                   ; sign into C
    ld a,h
    push af                     ; save exponent and sign in C

    or a                        ; divide by zero?
    jr Z,divovl                 ; we want one pop for sign at exit

    ld h,0bfh                   ; scale to -0.5 <= D' < -1.0
    srl l
    ex de,hl                    ; - D' in DEHL

    push de                     ; - D' msw on stack for D[2] calculation
    push hl                     ; - D' lsw on stack for D[2] calculation
    push de                     ; - D' msw on stack for D[1] calculation
    push hl                     ; - D' lsw on stack for D[1] calculation

    rl de                       ; get D' full exponent into d
    res 7,c                     ; set D' positive
    scf
    rr e                        ; put implicit bit for mantissa in ehl
    ld b,d                      ; unpack IEEE to expanded float 32-bit mantissa
    ld d,e
    ld e,h
    ld h,l
    ld l,0
;-------------------------------;
                                ; X = 140/33 + (-64/11 + 256/99 x D') x D'
    exx
    ld bc,04087h                ; (float) 140/33
    push bc
    ld bc,0c1f0h
    push bc
    exx
    push bc                     ; D' exp sign on stack for D[0] calculation
    push de                     ; D' msw on stack for D[0] calculation
    push hl                     ; D' lsw on stack for D[0] calculation
    exx
    ld bc,0c0bah                ; (float) -64/11
    push bc
    ld bc,02e8ch
    push bc
    ld bc,04025h                ; (float) 256/99
    push bc
    ld bc,07eb5h
    push bc
    exx
    call m32_fsmul24x32         ; (float) 256/99 × D'
    call m32_fsadd24x32         ; (float) X = -64/11 + 256/99 × D'
    call m32_fsmul32x32         ; (float) X = (-64/11 + 256/99 × D') x D'
    call m32_fsadd24x32         ; (float) X = 140/33 + (-64/11 + 256/99 × D') x D'

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[1] calculation
    pop de
    exx
    push bc                     ; X
    push de
    push hl
    push bc                     ; X
    push de
    push hl
    exx
    ld bc,03f80h                ; 1.0
    push bc
    ld bc,0
    push bc
    push de                      ; - D' for D[1] calculation
    push hl
    exx
    call m32_fsmul24x32         ; (float) - D' × X
    call m32_fsadd24x32         ; (float) 1 - D' × X
    call m32_fsmul32x32         ; (float) X × (1 - D' × X)
    call m32_fsadd32x32         ; (float) X + X × (1 - D' × X)

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[2] calculation
    pop de
    exx
    push bc                     ; X
    push de
    push hl
    push bc                     ; X
    push de
    push hl
    exx
    ld bc,03f80h                ; 1.0
    push bc
    ld bc,0
    push bc
    push de                      ; - D' for D[2] calculation
    push hl
    exx
    call m32_fsmul24x32         ; (float) - D' × X
    call m32_fsadd24x32         ; (float) 1 - D' × X
    call m32_fsmul32x32         ; (float) X × (1 - D' × X)
    call m32_fsadd32x32         ; (float) X + X × (1 - D' × X)

;-------------------------------;

    pop af                      ; recover D exponent and sign in C
    rr c                        ; save sign in c
    sub a,07fh                  ; calculate new exponent for 1/D
    neg
    add a,07eh
    ld b,a

    ld a,l
    ld l,h                      ; align 32-bit mantissa to IEEE 24-bit mantissa
    ld h,e
    ld e,d

    or a                        ; round using feilipu method
    jr Z,fd0
    inc l
    jr NZ,fd0
    inc h
    jr NZ,fd0
    inc e
    jr NZ,fd0
    rr e
    rr hl
    inc b

.fd0
    sla e
    sla c                       ; recover sign from c
    rr b
    rr e
    ld d,b
    ret                         ; return IEEE DEHL
