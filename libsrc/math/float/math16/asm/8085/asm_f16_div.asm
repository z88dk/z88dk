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
; Restoring 16-bit mant (stack locals; no exx / IX / djnz / bit):
;   rem in A:HL, div on stack, quot in DE
;   trial: sub hl,bc / sbc a,0; restore on borrow; rem <<= 1
;   2× unroll (8×2 bits).  rl de for quot bit.
;
; sccz80 half: HL = y, stack = [uret][x] → HL = x/y
;
; Internal body entry (div_body):
;   DEHL = X (dividend)
;   stack = [cret][Y.hl][Y.de][ ... caller words ... ]
;   Exit: DEHL = result; stack = [cret][ ... caller words ... ]
;         (Y consumed)
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


;--------------------------------------------------------------------
; half: HL=y, [uret][x] → HL = x/y
;--------------------------------------------------------------------
.asm_f16_div_callee
    call asm_f24_f16            ; y → f24
    push de
    push hl                     ; [y.hl][y.de][uret][x]
    ld de,sp+6
    ld hl,(de)                  ; x half
    call asm_f24_f16            ; DEHL = x
    call div_body               ; Y consumed; [uret][x]
    pop bc
    pop af                      ; drop x half
    push bc
    jp asm_f16_f24

;--------------------------------------------------------------------
; f24: DEHL=Y, [cret][X.hl][X.de] → DEHL = X/Y; stack [cret]
;--------------------------------------------------------------------
.asm_f24_div_callee
.asm_f24_div_f24
    pop bc                      ; cret
    push de
    push hl                     ; [Y.hl][Y.de][X.hl][X.de]
    ; DEHL ← X (under Y)
    ld de,sp+4
    ld hl,(de)                  ; X.hl
    push hl
    ld de,sp+8
    ld hl,(de)                  ; X.de
    ld de,hl
    pop hl                      ; DEHL = X
    ; stack [Y.hl][Y.de][X.hl][X.de], BC=cret
    push bc                     ; [cret][Y.hl][Y.de][X.hl][X.de]
    call div_body               ; Y consumed → [cret][X.hl][X.de]
    pop bc                      ; cret
    pop af                      ; X.hl
    pop af                      ; X.de
    push bc
    ret


;--------------------------------------------------------------------
; div_body: DEHL=X, [cret][Y.hl][Y.de][rest...] → DEHL=X/Y, [cret][rest...]
;--------------------------------------------------------------------
.div_body
    push de
    push hl                     ; [X.hl][X.de][cret][Y.hl][Y.de][rest...]
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
    jp Z,d_y_zero
    cp 255
    jp Z,d_y_hi
    ld de,sp+3
    ld a,(de)                   ; X.exp
    or a
    jp Z,d_x_zero
    cp 255
    jp Z,d_x_hi
    ; expR = X.exp - Y.exp + 127
    ld e,b                      ; Y.exp
    ld d,a                      ; X.exp in D; A also X.exp
    sub e
    ld e,a
    ld d,0
    jp NC,d_ep
    ld d,0ffh
.d_ep
    ld hl,127
    add hl,de
    ld a,h
    or a
    jp NZ,d_exp_bad
    ld a,l
    cp 255
    jp NC,d_of
    or a
    jr NZ,d_eok
    inc a
.d_eok
    ld b,a                      ; B=expR C=sign
    push bc                     ; [expR/sign][X.hl][X.de][cret][Y.hl][Y.de]...
    ;               +0          +2    +4    +6    +8    +10

    ld de,sp+2
    ld hl,(de)                  ; rem = X.mant
    ld de,sp+8
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a                      ; BC = Y.mant

    xor a
    push hl
    sub hl,bc
    pop hl
    jr NC,d_pre_ok
    add hl,hl
    rla
    push af
    ld de,sp+3
    ld a,(de)
    dec a
    ld (de),a
    pop af
.d_pre_ok
    push bc                     ; [div][expR/sign][X...][cret][Y...]
    ld bc,8
    push bc                     ; [count][div][expR/sign]...
    ld de,0

.d_lp
    push de
    push af
    ld de,sp+6
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    pop af

    or a
    sub hl,bc
    sbc a,0
    jr C,d_ns1
    scf
    jr d_q1

.d_ns1
    add hl,bc
    adc a,0
    or a
.d_q1
    pop de
    rl de
    add hl,hl
    rla

    push de
    push af
    ld de,sp+6
    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    pop af

    or a
    sub hl,bc
    sbc a,0
    jr C,d_ns2
    scf
    jr d_q2

.d_ns2
    add hl,bc
    adc a,0
    or a
.d_q2
    pop de
    rl de
    add hl,hl
    rla

    ; dec count without clobbering rem hi in A
    push de
    push af
    ld de,sp+4                  ; [af][quot][count]...
    ld a,(de)
    dec a
    ld (de),a
    jr Z,d_loop_done
    pop af
    pop de
    jr d_lp

.d_loop_done
    pop af                      ; rem hi (discard)
    pop de                      ; quot
    pop bc                      ; count
    pop bc                      ; div
    pop bc                      ; B=expR C=sign

    ld a,d
    and 080h
    jr NZ,d_normed
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    dec b
.d_normed
    ld a,b
    or a
    jp Z,d_res_zero
    cp 255
    jp NC,d_res_inf
    ld hl,de
    ld de,bc                    ; DEHL = result

    ; drop X.hl X.de cret Y.hl Y.de; restore cret
    ; stack: X.hl X.de cret Y.hl Y.de rest...
    pop bc                      ; X.hl
    pop af                      ; X.de
    pop bc                      ; cret
    pop af                      ; Y.hl
    pop af                      ; Y.de
    push bc                     ; cret
    ret

; ---- specials (stack [X.hl][X.de][cret][Y.hl][Y.de]..., C=sign) ----

.d_y_zero
    ld de,sp+3
    ld a,(de)
    or a
    jr NZ,d_to_inf
    jp d_to_nan

.d_x_zero
    jp d_to_zero

.d_y_hi
    ld de,sp+6
    ld hl,(de)
    ld a,h
    or l
    jr NZ,d_to_nan
    ld de,sp+3
    ld a,(de)
    cp 255
    jr NZ,d_to_zero
    jp d_to_nan

.d_x_hi
    ld de,sp+0
    ld hl,(de)
    ld a,h
    or l
    jr NZ,d_to_nan
    jp d_to_inf

.d_exp_bad
    ld a,h
    rla
    jr C,d_to_zero
.d_of
    jp d_to_inf

.d_to_zero
    ld e,c
    pop af
    pop af
    pop bc
    pop af
    pop af
    push bc
    jp asm_f24_zero

.d_to_inf
    ld e,c
    pop af
    pop af
    pop bc
    pop af
    pop af
    push bc
    jp asm_f24_inf

.d_to_nan
    pop af
    pop af
    pop bc
    pop af
    pop af
    push bc
    ld hl,0c000h
    ld de,0ff00h
    ret

.d_res_zero
    ld e,c
    pop af
    pop af
    pop bc
    pop af
    pop af
    push bc
    jp asm_f24_zero

.d_res_inf
    ld e,c
    pop af
    pop af
    pop bc
    pop af
    pop af
    push bc
    jp asm_f24_inf
