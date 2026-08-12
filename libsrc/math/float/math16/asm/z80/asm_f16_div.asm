;
;  feilipu, 2020 May / 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div / asm_f24_div — z80 half / f24 restoring divide
;-------------------------------------------------------------------------
;
; f24: D=exp (bias 127), E[7]=sign, HL=16-bit left-aligned mant.
;
; Hot path (register map, held for all 16 bits):
;   A:HL = rem (17-bit; A is the high bit)
;   BC   = div (full 16-bit mant)
;   DE   = quot
;   B'   = bit count (exx)
;
;   trial : or a; sbc hl,bc; sbc a,0; restore on borrow
;   rem<< : add hl,hl / rla
;   qbit  : rl de
;
; Labels match asm/8085/asm_f16_div.asm.  Specials use asm_f24_zero/inf/nan.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_zero
EXTERN asm_f24_inf
EXTERN asm_f24_nan

PUBLIC asm_f16_div_callee
PUBLIC asm_f24_div_callee
PUBLIC asm_f24_div_f24


;=========================================================================
; half: y in DEHL path via expand; x under ret
;=========================================================================

.asm_f16_div_callee
    call asm_f24_f16            ; y → f24 DEHL
    exx
    pop hl
    ex (sp),hl                  ; x half; ret on stack
    call asm_f24_f16            ; x → f24
    call asm_f24_div_f24
    jp asm_f16_f24


;=========================================================================
; f24: main = x after setup; alt = y
;=========================================================================

.asm_f24_div_callee
    exx                         ; y (divisor) → alt
    pop bc                      ; ret
    pop hl
    pop de                      ; x (dividend) → main
    push bc

; main = x, alt = y
.asm_f24_div_f24
.div_body
    ld a,e
    exx
    xor e
    and 080h
    exx
    ex af,af                    ; A' = sign

    ld a,d
    or a
    jp Z,div_x_zero             ; 0 / y
    cp 255
    jp Z,div_x_hi
    exx                         ; → y
    ld a,d
    or a
    jp Z,div_y_zero             ; x / 0
    cp 255
    jp Z,div_y_hi
    ; finite: park y then x
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
    jr Z,div_exp_sx
    ld d,0ffh
.div_exp_sx
    push hl                     ; mant_x
    ld hl,127
    add hl,de
    bit 7,h
    jp NZ,div_underflow
    ld a,h
    or a
    jp NZ,div_overflow
    ld a,l
    cp 255
    jp NC,div_overflow
    or a
    jp Z,div_underflow          ; exp 0 → signed zero
    ld e,a                      ; E = expR
    pop hl                      ; mant_x = rem

;----- prenorm -----------------------------------------------------------
    xor a
    push hl
    or a
    sbc hl,bc
    pop hl
    jr NC,div_prenorm_ok
    add hl,hl
    rla
    dec e
.div_prenorm_ok
    ld d,e                      ; D = expR
    push de                     ; save expR in D (E unused)
    ld de,0                     ; quot
    exx
    ld b,16
    exx

;=========================================================================
; Hot path — 16 bits.  BC=div, A:HL=rem, DE=quot, B'=count
;=========================================================================

.div_bit_loop
    or a                        ; C clear for sbc hl,bc
    sbc hl,bc
    sbc a,0
    jr C,div_bit_fail
    scf
    jr div_quot_shift

.div_bit_fail
    add hl,bc
    adc a,0
    or a
.div_quot_shift
    rl de
    add hl,hl
    rla
    exx
    djnz div_bit_next
    exx
    jr div_pack

.div_bit_next
    exx
    jr div_bit_loop

;=========================================================================
; Pack
;=========================================================================

.div_pack
    pop bc                      ; B = expR
    bit 7,d
    jr NZ,div_normed
    sla e
    rl d
    dec b
.div_normed
    ld a,b
    or a
    jp Z,div_zero
    cp 255
    jp NC,div_inf
    ex de,hl                    ; HL = quot
    ld d,b
    ex af,af
    ld e,a                      ; sign
    ret

;=========================================================================
; Specials — sign in A'
;=========================================================================

.div_underflow
    pop hl                      ; drop mant_x if parked
    jp div_zero

.div_overflow
    pop hl
    jp div_inf

.div_x_zero
    ; 0 / y  (main = x zero)
    jp div_zero

.div_x_hi
    ld a,h
    or l
    jp NZ,div_nan
    exx
    ld a,d
    cp 255
    jr NZ,div_inf_sw
    ld a,h
    or l
    jp Z,div_nan
    jp div_inf_sw

.div_y_zero
    ; x / 0 → inf (alt = y was zero; still on alt)
    jp div_inf_sw

.div_y_hi
    ld a,h
    or l
    jp NZ,div_nan
    exx
    jp div_zero

.div_zero
    ex af,af
    ld e,a
    jp asm_f24_zero

.div_inf_sw
    exx
.div_inf
    ex af,af
    ld e,a
    jp asm_f24_inf

.div_nan
    jp asm_f24_nan
