;
;  feilipu / specials, 2026
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; IEEE-side specials for am9511 float ops
;-------------------------------------------------------------------------
;
; Am9511 APU: 24-bit mantissa, unbiased 7-bit exp (−64…+63), no Inf/NaN.
; pushf maps IEEE exp ≥ 190 (including 255) to APU max — Inf/NaN must be
; handled here before the chip.  On-chip errors (see popf) follow the status
; register in techdocs/amd/am9511a (Am9511 Arithmetic Processor.pdf).
;   OVRFL → ±Inf, UNDFL/ZERO → 0, DIV0 → ±Inf, NEGRT → NaN.
;
; Binary: DEHL = RHS y; stack = ret_spec, ret_user, x as L,H,E,D.
; Exit: CF=1 DEHL=result handled; CF=0 DEHL=y use APU.  x not consumed.
;
; Sqrt: DEHL = x; stack = ret_spec, ret_user.
;
; 8080-compatible (no exx / IX).
;
; Algebra (IEEE host):
;   div:  x/0 → ±Inf (0/0 → NaN); finite/Inf → 0; Inf/Inf → NaN; Inf/fin → Inf
;   mul:  0×Inf → NaN; Inf×finite → ±Inf; 0×finite → 0
;   add:  Inf±finite → Inf; Inf−Inf → NaN; finite+0 → finite (return x)
;   sqrt: sqrt(−) → NaN; sqrt(+Inf) → +Inf; sqrt(0) → 0
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_spec_div
PUBLIC asm_am9511_spec_mul
PUBLIC asm_am9511_spec_add
PUBLIC asm_am9511_spec_sqrt


; A = IEEE exponent of DEHL (sign discarded).  DEHL unchanged.
.ieee_exp
    ld a,e
    add a,a
    ld a,d
    adc a,a
    ret

; HL = offset from SP after CALL into this helper.
; Preserve BC: callers stash operand sign in C across this load.
.load_xo
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = x low
    inc hl
    push de
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = x high
    pop hl                      ; HL = x low
    ret

.load_x10
    ld hl,10
    jr load_xo

.ret_pnan
    ld de,07fffh
    ld h,e
    ld l,e
    scf
    ret

.ret_szero
    ld de,0
    ld h,d
    ld l,e
    scf
    ret

; B.7 = result sign → ±Inf
.ret_sinf_b
    ld hl,0
    ld e,080h
    ld a,b
    and 080h
    or 07fh
    ld d,a
    scf
    ret

; Z if mantissa is zero (Inf), NZ if NaN.  DEHL = IEEE value.
.mant_nz
    ld a,e
    and 07fh
    or h
    or l
    ret


;=========================================================================
; DIV  — y = DEHL (divisor), x on stack (dividend)
;=========================================================================
.asm_am9511_spec_div
    call ieee_exp
    or a
    jp Z,div_y_zero
    inc a
    jp Z,div_y_max

    ; y finite nonzero: only x Inf/NaN needs software
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,div_apu                ; x finite or 0 → APU
    inc a
    jr NZ,div_apu
    call mant_nz
    jr NZ,div_x_nan
    ld a,d
    and 080h
    ld b,a                      ; sx
    pop hl
    pop de
    ld a,d
    and 080h
    xor b
    ld b,a
    jp ret_sinf_b               ; Inf / finite → ±Inf

.div_x_nan
    pop hl
    pop de
    jp ret_pnan

.div_apu
    pop hl
    pop de
    or a                        ; CF=0 → APU
    ret

; y == 0
.div_y_zero
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    ld a,d
    and 080h
    xor c
    ld b,a                      ; result sign
    call ieee_exp
    pop hl
    pop de
    or a
    jp Z,ret_pnan               ; 0/0
    jp ret_sinf_b               ; finite|Inf / 0 → ±Inf

; y.exp == 255
.div_y_max
    call mant_nz
    jp NZ,ret_pnan              ; y NaN
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,div_zero_over_inf
    inc a
    jr NZ,div_fin_over_inf
    call mant_nz
    pop hl
    pop de
    jp ret_pnan                 ; Inf/Inf or NaN/Inf

.div_zero_over_inf
    pop hl
    pop de
    jp ret_szero                ; 0 / Inf → 0

.div_fin_over_inf
    pop hl
    pop de
    jp ret_szero                ; finite / Inf → 0


;=========================================================================
; MUL  — y = DEHL, x on stack
;=========================================================================
.asm_am9511_spec_mul
    call ieee_exp
    or a
    jp Z,mul_y_zero
    inc a
    jp Z,mul_y_max

    ; y finite nonzero: only x Inf/NaN needs software
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,mul_apu
    inc a
    jr NZ,mul_apu
    call mant_nz
    jr NZ,mul_x_nan
    ld a,d
    and 080h
    ld b,a
    pop hl
    pop de
    ld a,d
    and 080h
    xor b
    ld b,a
    jp ret_sinf_b               ; Inf × finite → ±Inf

.mul_x_nan
    pop hl
    pop de
    jp ret_pnan

.mul_apu
    pop hl
    pop de
    or a
    ret

; y == 0
.mul_y_zero
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,mul_zero_out
    inc a
    jr NZ,mul_zero_out
    pop hl
    pop de
    jp ret_pnan                 ; Inf|NaN × 0 → NaN

.mul_zero_out
    pop hl
    pop de
    jp ret_szero                ; 0 × finite or 0 × 0

; y.exp == 255
.mul_y_max
    call mant_nz
    jp NZ,ret_pnan              ; y NaN
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    ld a,d
    and 080h
    xor c
    ld b,a                      ; result sign
    call ieee_exp
    or a
    jr Z,mul_inf_times_zero
    inc a
    jr Z,mul_inf_times_max
    pop hl
    pop de
    jp ret_sinf_b               ; Inf × finite

.mul_inf_times_zero
    pop hl
    pop de
    jp ret_pnan                 ; Inf × 0

.mul_inf_times_max
    call mant_nz
    pop hl
    pop de
    jp NZ,ret_pnan              ; Inf × NaN
    jp ret_sinf_b               ; Inf × Inf


;=========================================================================
; ADD  — y = DEHL, x on stack
;=========================================================================
.asm_am9511_spec_add
    call ieee_exp
    or a
    jp Z,add_y_zero
    inc a
    jp Z,add_y_max

    ; y finite nonzero: only x Inf/NaN needs software
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,add_apu
    inc a
    jr NZ,add_apu
    call mant_nz
    jr NZ,add_x_nan
    pop bc
    pop bc
    scf                         ; DEHL = x Inf (return Inf)
    ret

.add_x_nan
    pop hl
    pop de
    jp ret_pnan

.add_apu
    pop hl
    pop de
    or a
    ret

; y == 0 → result is x
.add_y_zero
    push de
    push hl
    call load_x10
    pop bc
    pop bc
    scf
    ret

; y.exp == 255
.add_y_max
    call mant_nz
    jp NZ,ret_pnan              ; y NaN
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    ld a,d
    and 080h
    ld b,a                      ; sx
    call ieee_exp
    or a
    jr Z,add_inf_plus_zero
    inc a
    jr Z,add_inf_plus_max
    ; finite + Inf → y Inf
    pop hl
    pop de
    ld b,c
    jp ret_sinf_b

.add_inf_plus_zero
    pop hl
    pop de
    ld b,c
    jp ret_sinf_b               ; Inf + 0 → Inf

.add_inf_plus_max
    call mant_nz
    jr NZ,add_inf_nan
    ld a,b
    xor c
    and 080h
    jr NZ,add_inf_nan           ; Inf − Inf
    pop hl
    pop de
    ld b,c
    jp ret_sinf_b               ; Inf + Inf same sign

.add_inf_nan
    pop hl
    pop de
    jp ret_pnan


;=========================================================================
; SQRT  — x = DEHL
;=========================================================================
.asm_am9511_spec_sqrt
    call ieee_exp
    or a
    jp Z,ret_szero              ; sqrt(±0) → +0
    inc a
    jr NZ,sqrt_finite
    call mant_nz
    jp NZ,ret_pnan              ; sqrt(NaN)
    ld a,d
    rla
    jp C,ret_pnan               ; sqrt(−Inf)
    ld b,0
    jp ret_sinf_b               ; sqrt(+Inf) → +Inf

.sqrt_finite
    ld a,d
    rla
    jp C,ret_pnan               ; sqrt(negative)
    or a                        ; CF=0 → APU
    ret
