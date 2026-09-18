;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_base16 — hex conversion helper (stack-only, DEHL)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_base16


.m32__dtoa_base16
    ; enter : dehl = float x, x positive
    ;
    ; exit  : hl = mantissa *
    ;         de = stack adjust (4)
    ;          c = max significant hex digits (6)
    ;          b = base 2 exponent e
    ;
    ; uses  : af, bc, de, hl

    pop bc                          ; ret

    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a                          ; D = exp
    ld a,d
    push af                         ; exp
    scf
    ld a,e
    rra
    ld e,a                          ; hidden bit
    pop af                          ; A = exp
    push de
    push hl                         ; mantissa
    push bc                         ; ret

    sub 07eh
    ld b,a                          ; b = base 2 exponent
    ld hl,4
    add hl,sp                       ; hl = mantissa *
    ld de,4
    ld c,6
    ret
