;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 frexpf — fraction and exponent (core ABI matches am9511 / Z80).
;
; Core m32_fsfrexp_callee:
;   enter : stack = float *pw2, float x, ret
;         : SP = ret, x.HL, x.DE, ptr
;
; _m32_frexpf (sccz80 higher C / public bridge):
;   enter : SP = ret, ptr, x.HL, x.DE  — reverse then core
;
; Uses ld de,sp+d and ld hl,(de). Never parks ret in AF.
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsfrexp_callee
PUBLIC _m32_frexpf


; sccz80 left-to-right entry → core order (same as cam32_sccz80_frexp_callee)
._m32_frexpf
    pop hl                          ; ret
    pop bc                          ; ptr
    pop de                          ; x.HL
    ex (sp),hl                      ; HL = x.DE; (sp) = ret
    push bc                         ; ptr
    push hl                         ; x.DE
    push de                         ; x.HL : SP = x.HL, x.DE, ptr, ret
    call m32_fsfrexp_callee
    ret


; float frexpf (float x, int *pw2) — core (SDCC / am9511 order)
; enter : SP = ret, x.HL, x.DE, ptr
; exit  : DEHL = fraction in [0.5, 1); *pw2 = frexp exponent
.m32_fsfrexp_callee
    ; SP+0 ret, SP+2 x.HL, SP+4 x.DE, SP+6 ptr
    ld de,sp+4
    ld hl,(de)                      ; HL = x.DE

    add hl,hl                       ; exp → H, mant bits → L, sign → C
    ld a,h
    or a
    jp Z,frexp_zero
    ld h,07eh                       ; bias-1 → fraction in [0.5, 1)
    sub h                           ; A = unbiased frexp exponent

.frexp_zero
    ld de,sp+6                      ; address of ptr on stack
    ex de,hl                        ; DE = work; HL → ptr slot
    ld c,(hl+)
    ld b,(hl)
    ex de,hl                        ; HL = work again

    ld (bc),a
    inc bc
    rlca
    sbc a,a
    ld (bc),a                       ; *pw2 = sign-extended exp

    ld de,sp+5                      ; original D (sign + exp of x)
    ld a,(de)
    rla                             ; sign → C
    ld a,h                          ; 0 or 0x7e
    rra
    ld d,a
    ld a,l
    rra
    ld e,a                          ; DE = fraction high word

    pop bc                          ; ret
    pop hl                          ; HL = x.HL (mant LSW)
    inc sp
    inc sp                          ; drop x.DE
    inc sp
    inc sp                          ; drop ptr
    push bc                         ; ret
    ret
