;
;  feilipu, 2020 May / 2026 August (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div / asm_f24_div — 8085 half / f24 restoring divide
;-------------------------------------------------------------------------
;
; f24: D=exp (bias 127), E[7]=sign, HL=16-bit left-aligned mant.
;
; Hot path (register map, held for all 16 bits):
;   A:HL = rem (17-bit; A is the high bit)
;   BC   = div (full 16-bit mant)
;   DE   = quot
;   stack +0 = bit count (B is part of BC)
;
;   trial : sub hl,bc / sbc a,0; restore on borrow  (DSUB, no C-in)
;   rem<< : add hl,hl / rla
;   qbit  : rl de
;
; Labels match asm/z80/asm_f16_div.asm.  Specials use asm_f24_zero/inf/nan.
;
; sccz80 half: HL = y, stack = [uret][x] → HL = x/y
;
; div_body:
;   DEHL = X; stack = [cret][Y.hl][Y.de][...]
;   → DEHL = X/Y; stack = [cret][...]  (Y consumed)
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
; half: HL=y, [uret][x] → HL = x/y
;=========================================================================

.asm_f16_div_callee
    call asm_f24_f16            ; y → f24
    push de
    push hl                     ; [y.hl][y.de][uret][x]
    ld de,sp+6
    ld hl,(de)                  ; x half
    call asm_f24_f16            ; DEHL = x
    call div_body
    pop bc
    pop af                      ; drop x half
    push bc
    jp asm_f16_f24


;=========================================================================
; f24: DEHL=Y, [cret][X.hl][X.de] → DEHL = X/Y; stack [cret]
;=========================================================================

.asm_f24_div_callee
.asm_f24_div_f24
    pop bc                      ; cret
    push de
    push hl                     ; [Y.hl][Y.de][X.hl][X.de]
    ld de,sp+4
    ld hl,(de)                  ; X.hl
    push hl
    ld de,sp+8
    ld hl,(de)                  ; X.de
    ex de,hl
    pop hl                      ; DEHL = X
    push bc                     ; [cret][Y...][X...]
    call div_body
    pop bc                      ; cret
    pop af                      ; X.hl
    pop af                      ; X.de
    push bc
    ret


;=========================================================================
; div_body
;=========================================================================

.div_body
    push de
    push hl                     ; [X.hl][X.de][cret][Y.hl][Y.de]...
    ;               +0    +2    +4    +6    +8

    ; sign = X.E xor Y.E
    ld de,sp+2
    ld a,(de)                   ; X.E
    ld de,sp+8
    ld l,a
    ld a,(de)                   ; Y.E
    xor l
    and 080h
    ld c,a                      ; C = sign

    ld de,sp+9
    ld a,(de)                   ; Y.exp
    ld b,a
    or a
    jp Z,div_y_zero
    cp 255
    jp Z,div_y_hi
    ld de,sp+3
    ld a,(de)                   ; X.exp
    or a
    jp Z,div_x_zero
    cp 255
    jp Z,div_x_hi

    ; expR = X.exp - Y.exp + 127
    ld e,b                      ; Y.exp
    ld d,a                      ; X.exp
    sub e
    ld e,a
    ld d,0
    jp NC,div_exp_sx
    ld d,0ffh
.div_exp_sx
    ld hl,127
    add hl,de
    ld a,h
    or a
    jp NZ,div_exp_bad
    ld a,l
    cp 255
    jp NC,div_overflow
    or a
    jp Z,div_underflow          ; exp 0 → signed zero
    ld b,a                      ; B=expR C=sign
    push bc                     ; [expR/sign][X...][cret][Y...]

    ld de,sp+2
    ld hl,(de)                  ; rem = X.mant
    ld de,sp+8
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a                      ; BC = Y.mant = div

;----- prenorm -----------------------------------------------------------
    xor a
    push hl
    sub hl,bc
    pop hl
    jr NC,div_prenorm_ok
    add hl,hl
    rla
    push af
    ld de,sp+3
    ld a,(de)
    dec a
    ld (de),a
    pop af
.div_prenorm_ok
    ; BC=div held, A:HL=rem
    ld de,16
    push de                     ; [count][expR/sign][X...][cret][Y...]
    ld de,0                     ; quot

;=========================================================================
; Hot path — 16 bits.  BC=div, A:HL=rem, DE=quot, count on stack
;=========================================================================

.div_bit_loop
    ; trial (DSUB has no borrow-in)
    sub hl,bc
    sbc a,0
    jr C,div_bit_fail
    scf
    jr div_quot_shift

.div_bit_fail
    add hl,bc
    adc a,0
    or a                        ; qbit = 0
.div_quot_shift
    rl de
    add hl,hl
    rla

    ; dec count: preserve A (rem hi) and DE (quot); Z from dec (hl)
    push de
    ld de,sp+2                  ; &count
    push hl
    ex de,hl                    ; HL = &count
    dec (hl)
    pop hl                      ; rem.lo
    pop de                      ; quot
    jp NZ,div_bit_loop

;=========================================================================
; Pack
;=========================================================================

    pop bc                      ; drop count
    pop bc                      ; B=expR C=sign

    ld a,d
    and 080h
    jr NZ,div_normed
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    dec b
.div_normed
    ld a,b
    or a
    jp Z,div_res_zero
    cp 255
    jp NC,div_res_inf
    ex de,hl                    ; HL = quot
    ld de,bc                    ; D=expR E=sign

    ; drop X.hl X.de cret Y.hl Y.de; restore cret
    pop bc                      ; X.hl
    pop af                      ; X.de
    pop bc                      ; cret
    pop af                      ; Y.hl
    pop af                      ; Y.de
    push bc
    ret

;=========================================================================
; Specials — stack [X.hl][X.de][cret][Y.hl][Y.de]..., C=sign
;=========================================================================

.div_y_zero
    ; Y is 0; X at sp+3 exp
    ld de,sp+3
    ld a,(de)
    or a
    jp Z,div_to_nan             ; 0/0
    cp 255
    jp NZ,div_to_inf            ; finite/0 → inf
    ; X exp 255: NaN or Inf over 0
    ld de,sp+0
    ld hl,(de)
    ld a,h
    or l
    jp NZ,div_to_nan            ; NaN/0
    jp div_to_inf               ; Inf/0 → Inf

.div_x_zero
    ; X is 0; inspect Y
    ld de,sp+9
    ld a,(de)                   ; Y.exp
    or a
    jp Z,div_to_nan             ; 0/0
    cp 255
    jp NZ,div_to_zero           ; 0/finite → 0
    ld de,sp+6
    ld hl,(de)                  ; Y.mant
    ld a,h
    or l
    jp NZ,div_to_nan            ; 0/NaN
    jp div_to_zero              ; 0/inf → 0

.div_y_hi
    ; Y exp 255
    ld de,sp+6
    ld hl,(de)
    ld a,h
    or l
    jp NZ,div_to_nan            ; y NaN
    ld de,sp+3
    ld a,(de)                   ; X.exp
    cp 255
    jp Z,div_to_nan             ; Inf/Inf (X mant checked? if X NaN caught earlier)
    jp div_to_zero              ; finite/Inf → 0

.div_x_hi
    ; X exp 255
    ld de,sp+0
    ld hl,(de)
    ld a,h
    or l
    jp NZ,div_to_nan            ; X NaN
    ld de,sp+9
    ld a,(de)                   ; Y.exp
    cp 255
    jp NZ,div_to_inf            ; Inf/finite → Inf
    ld de,sp+6
    ld hl,(de)
    ld a,h
    or l
    jp Z,div_to_nan             ; Inf/Inf
    jp div_to_nan               ; Inf/NaN

.div_exp_bad
    ld a,h
    rla
    jr C,div_to_zero
.div_overflow
    jp div_to_inf

.div_underflow
.div_to_zero
    ld e,c
    call div_drop5
    jp asm_f24_zero

.div_to_inf
    ld e,c
    call div_drop5
    jp asm_f24_inf

.div_to_nan
    call div_drop5
    jp asm_f24_nan

.div_res_zero
    ld e,c
    call div_drop5
    jp asm_f24_zero

.div_res_inf
    ld e,c
    call div_drop5
    jp asm_f24_inf

; drop X.hl X.de cret Y.hl Y.de; leave cret on stack.  Preserves DE/HL/A/C as used.
.div_drop5
    pop hl                      ; return to special
    pop af                      ; X.hl
    pop af                      ; X.de
    pop bc                      ; cret
    pop af                      ; Y.hl
    pop af                      ; Y.de
    push bc                     ; cret
    jp (hl)
