;
;  feilipu, 2020 May / 2026 August (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_inv / asm_f24_inv — 8085 half float reciprocal (Newton–Raphson)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_inf
EXTERN asm_f24_mul_callee
EXTERN asm_f24_add_callee

PUBLIC asm_f16_inv
PUBLIC asm_f24_inv


.asm_f16_inv
    ld a,$7c
    and h
    cp $7c
    jp Z,inv_half_max
    call asm_f24_f16
    call asm_f24_inv
    jp asm_f16_f24

.inv_half_max
    ld a,h
    and 003h
    or l
    jp NZ,inv_half_nan
    and a
    ld a,h
    and 080h
    ld h,a
    ld l,0
    ret

.inv_half_nan
    ld hl,07C80h
    ret


.asm_f24_inv
    ld a,d
    or a
    jp Z,asm_f24_inf

    push de                     ; [orig]

    ld de,07e80h                ; D' scale, e[7]=1 (negative)

    push de
    push hl                     ; D' for Newton 2
    push de
    push hl                     ; D' for Newton 1
    ; stack: [D'1][D'2][orig]

    ; polynomial X0 = 140/33 + (-64/11 + 256/99 * Dp) * Dp
    ld bc,08100h
    push bc
    ld bc,087c1h
    push bc                     ; 140/33
    ld a,e
    and 07fh
    ld e,a                      ; Dp positive
    push de
    push hl                     ; Dp
    ld bc,08180h
    push bc
    ld bc,0ba2fh
    push bc                     ; -64/11
    ld bc,08000h
    push bc
    ld bc,0a57fh
    push bc                     ; 256/99
    call asm_f24_mul_callee
    call asm_f24_add_callee
    call asm_f24_mul_callee
    call asm_f24_add_callee     ; DEHL = X0; stack [D'1][D'2][orig]

    call inv_newton
    call inv_newton

    pop bc                      ; B=orig.exp C=orig.sign (push de → low=E)
    ld a,b
    sub 07fh
    ld b,a
    xor a
    sub b
    add a,07eh
    ld d,a
    ld e,c
    ret


;--------------------------------------------------------------------
; X := X + X*(1 + D'*X)  with D' negative ⇒ 1 - |D|*X
; Entry: DEHL=X, stack=[D'.hl][D'.de]...
;--------------------------------------------------------------------
.inv_newton
    ; CALL entry: [nret][D'.hl][D'.de]...
    push de
    push hl                     ; X for final add
    push de
    push hl                     ; X for second mul
    push de
    push hl                     ; X for D'*X
    ; stack [Xhl][Xde] x3 [nret][D'.hl][D'.de]...
    ;         +0..+10          +12  +14    +16

    ; DEHL = D', mul with X on stack
    ld de,sp+14
    ld hl,(de)                  ; D'.hl
    push hl
    ld de,sp+18                 ; D'.de at +16+2
    ld hl,(de)
    ex de,hl
    pop hl                      ; DEHL=D'
    call asm_f24_mul_callee     ; D'*X; [X][X][nret][D']...

    ld bc,07f00h
    push bc
    ld bc,08000h
    push bc                     ; 1.0
    call asm_f24_add_callee     ; 1+D'*X; [X][X][D']...

    call asm_f24_mul_callee     ; X*(1+D'*X); [X][nret][D']...
    call asm_f24_add_callee     ; X + that; [nret][D'.hl][D'.de]...

    ; drop D' under nret without losing DEHL result
    pop bc                      ; nret
    pop af                      ; D'.hl
    pop af                      ; D'.de
    push bc                     ; nret
    ret
