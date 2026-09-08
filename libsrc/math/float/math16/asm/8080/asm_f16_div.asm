;
;  feilipu, 2020 May / 2026 September (8080)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div / asm_f24_div — 8080 half / f24 restoring divide
;-------------------------------------------------------------------------
;
; f24: D=exp (bias 127), E[7]=sign, HL=16-bit left-aligned mant.
;
; Hot path (register map, held for all 16 bits):
;   A:HL = rem (17-bit; A is the high bit)
;   BC   = div (full 16-bit mant)
;   DE   = quot
;
;   trial : HL-BC through A, rem-hi parked (no DSUB)
;   rem<< : add hl,hl / rla
;   qbit  : rl de through A with rem-hi parked
;
; 16 bits via stacked ret (push div_pack, 15× div_bit, jp div_bit).
; Inner push de / push af sit above those words; ret still pops a continuation.
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
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a  ; x half
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
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a  ; X.hl
    push hl
    ld hl,sp+8
    ld a,(hl+)
    ld h,(hl)
    ld l,a  ; X.de
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
    ld hl,sp+2
    ld a,(hl)                   ; X.E
    ld c,a
    ld hl,sp+8
    ld a,(hl)                   ; Y.E
    xor c
    and 080h
    ld c,a                      ; C = sign

    ld hl,sp+9
    ld a,(hl)                   ; Y.exp
    ld b,a
    or a
    jp Z,div_y_zero
    cp 255
    jp Z,div_y_hi
    ld hl,sp+3
    ld a,(hl)                   ; X.exp
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

    ld hl,sp+8
    ld a,(hl+)
    ld c,a
    ld b,(hl)                   ; BC = Y.mant = div
    ld hl,sp+2
    ld a,(hl+)
    ld h,(hl)
    ld l,a                      ; rem = X.mant

;----- prenorm -----------------------------------------------------------
    xor a
    push hl
    ld a,l
    sub c
    ld a,h
    sbc a,b
    pop hl
    jr NC,div_prenorm_nc
    xor a
    add hl,hl
    rla
    ld de,hl                    ; park rem
    ld hl,sp+1                  ; &expR
    dec (hl)
    ld hl,de
    jr div_prenorm_ok
.div_prenorm_nc
    xor a                       ; rem hi = 0 (compare clobbered A)
.div_prenorm_ok
    ; DE free: push div_pack, 15× div_bit, jp div_bit.
    ; ret is 10c; call+ret is 27c.  Setup is one ld de,nn + 16 push.
    ld de,div_pack
    push de
    ld de,div_bit
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    ld de,0                     ; quot
    jp div_bit

;=========================================================================
; Pack
;=========================================================================

.div_pack

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

.div_bit
    push de                     ; quot
    push af                     ; rem hi in A (F unused; never pop af as a word)
    ld a,l
    sub c                       ; sub, not sbc: C-in must not enter the 16-bit trial
    ld l,a
    ld a,h
    sbc a,b
    ld h,a
    pop de                      ; D = rem hi
    ld a,d
    sbc a,0
    pop de                      ; quot
    jr C,div_bit_fail
    scf
    jr div_quot_shift
.div_bit_fail
    add hl,bc
    adc a,0
    or a
.div_quot_shift
    push af                     ; park rem hi; rl de through A
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
    pop af
    add hl,hl
    rla
    ret

;=========================================================================
; Specials — C = result sign; frame [X.hl][X.de][cret][Y…]
;=========================================================================
;   0/0 → NaN   0/finite|Inf → 0   finite/0 → Inf
;   Inf/Inf → NaN  Inf/finite → Inf  finite/Inf → 0  NaN/* → NaN

; Y.exp == 0
.div_y_zero
    ld hl,sp+3
    ld a,(hl)                   ; X.exp
    or a
    jp Z,div_to_nan             ; 0/0
    cp 255
    jp NZ,div_to_inf            ; finite/0 → Inf
    ld hl,sp+0
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp NZ,div_to_nan            ; NaN/0
    jp div_to_inf               ; Inf/0 → Inf

; X.exp == 0
.div_x_zero
    ld hl,sp+9
    ld a,(hl)                   ; Y.exp
    or a
    jp Z,div_to_nan             ; 0/0
    cp 255
    jp NZ,div_to_zero           ; 0/finite → 0
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a  ; Y.mant
    ld a,h
    or l
    jp NZ,div_to_nan            ; 0/NaN
    jp div_to_zero              ; 0/Inf → 0

; Y.exp == 255
.div_y_hi
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp NZ,div_to_nan            ; Y NaN
    ld hl,sp+3
    ld a,(hl)                   ; X.exp
    cp 255
    jp Z,div_to_nan             ; Inf/Inf (X NaN already handled at gate)
    jp div_to_zero              ; finite/Inf → 0

; X.exp == 255
.div_x_hi
    ld hl,sp+0
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp NZ,div_to_nan            ; X NaN
    ld hl,sp+9
    ld a,(hl)                   ; Y.exp
    cp 255
    jp NZ,div_to_inf            ; Inf/finite → Inf
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a
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
