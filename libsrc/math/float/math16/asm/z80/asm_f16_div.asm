;
;  feilipu, 2020 May / 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div / asm_f24_div - z80 half / f24 restoring divide
;-------------------------------------------------------------------------
;
; f24: D=exp (bias 127), E[7]=sign, HL=16-bit left-aligned mant.
;
; Restoring 16-bit mant (same strategy as math32 fsdiv):
;   rem in A:HL (17-bit), div in BC, quot in DE
;   trial: sbc hl,bc / sbc a,0; restore on borrow; rem <<= 1
;   1×: 16 steps × 1 bit (size; was 8×2).  No IX.
;
; Prenorm: if rem < div, rem<<=1 and exp-- so first quot bit is 1.
; asm_f24_inv remains for reciprocal-only use.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_zero
EXTERN asm_f24_inf

PUBLIC asm_f16_div_callee
PUBLIC asm_f24_div_callee
PUBLIC asm_f24_div_f24


.asm_f16_div_callee
    call asm_f24_f16            ; y → f24 DEHL
    exx
    pop hl
    ex (sp),hl                  ; x half; ret on stack
    call asm_f24_f16            ; x → f24
    call asm_f24_div_f24
    jp asm_f16_f24

.asm_f24_div_callee
    exx                         ; y (divisor) → alt
    pop bc                      ; ret
    pop hl
    pop de                      ; x (dividend) → main
    push bc

; main = x, alt = y
.asm_f24_div_f24
    ld a,e
    exx
    xor e
    and 080h
    exx
    ex af,af                    ; A' = sign

    ld a,d
    or a
    jp Z,d_zero                 ; 0 / y
    cp 255
    jp Z,d_xhi
    exx                         ; → y
    ld a,d
    or a
    jp Z,d_inf_sw               ; x / 0
    cp 255
    jp Z,d_yhi
    ; finite: stack exp_y, mant_y, then switch to x
    push hl                     ; mant_y
    ld a,d
    push af                     ; exp_y
    exx
    push hl                     ; mant_x
    ld a,d
    push af                     ; exp_x
    ; stack: exp_x, mant_x, exp_y, mant_y
    pop af                      ; exp_x
    ld d,a
    pop hl                      ; mant_x
    pop af                      ; exp_y
    ld e,a
    pop bc                      ; mant_y
    ; D=exp_x E=exp_y HL=mant_x BC=mant_y

    ld a,d
    sub e
    ld e,a
    ld d,0
    bit 7,a
    jr Z,d_ep
    ld d,0ffh
.d_ep
    push hl                     ; mant_x
    ld hl,127
    add hl,de
    bit 7,h
    jp NZ,d_uf
    ld a,h
    or a
    jp NZ,d_of
    ld a,l
    cp 255
    jp NC,d_of
    or a
    jp Z,d_uf                   ; exp 0 → flush zero (no subnormals)
    ld e,a                      ; E = expR
    pop hl                      ; mant_x = rem

    ; prenorm: if rem < div, rem<<=1 (17-bit), exp--
    ; leave rem in A:HL with A = high bit
    xor a
    push hl
    or a
    sbc hl,bc
    pop hl
    jr NC,d_lp0
    add hl,hl
    rla
    dec e

.d_lp0
    ld d,e                      ; D = expR
    push de                     ; save expR in D
    ld de,0                     ; quot
    ; A:HL = rem, BC = div; B' = bit-pair count
    exx
    ld b,16                     ; 16 × 1 bit
    exx

.d_lp
    ; --- bit: trial A:HL − 0:BC ---
    or a                        ; clear C (A holds rem bit16)
    sbc hl,bc
    sbc a,0
    jr C,d_ns1
    scf
    jr d_q1

.d_ns1
    add hl,bc
    adc a,0
    or a                        ; C = 0 → quot bit 0
.d_q1
    rl e
    rl d
    add hl,hl
    rla
    exx
    djnz d_lp_c
    exx
    jr d_done

.d_lp_c
    exx
    jr d_lp

.d_done
    ; DE = quot; (sp) = expR in D.  Half pack: no full RNE (EPSILON 0.005).
    pop bc                      ; B = expR
    bit 7,d
    jr NZ,d_normed
    sla e
    rl d
    dec b
.d_normed
    ld a,b
    or a
    jp Z,d_zero
    cp 255
    jp NC,d_inf
    ex de,hl                    ; HL = quot (DE dead; D/E refilled)
    ld d,b
    ex af,af
    ld e,a
    ret

.d_uf
    pop hl
    jp d_zero

.d_of
    pop hl
    jp d_inf

.d_xhi
    ld a,h
    or l
    jp NZ,d_nan
    exx
    ld a,d
    cp 255
    jr NZ,d_inf_sw
    ld a,h
    or l
    jp Z,d_nan
    jp d_inf_sw

.d_yhi
    ld a,h
    or l
    jp NZ,d_nan
    exx
    jp d_zero

.d_zero
    ex af,af
    ld e,a
    jp asm_f24_zero

.d_inf_sw
    exx
.d_inf
    ex af,af
    ld e,a
    jp asm_f24_inf

.d_nan
    ld hl,0c000h
    ld de,0ff00h
    ret
