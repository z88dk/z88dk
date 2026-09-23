;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_digits — generate decimal digits (8085)
;-------------------------------------------------------------------------
;
; DEHL = mantissa (top 4 bits of D = next decimal digit).
; B = digits to generate, C = remaining significant digits.
; Buffer pointer at workspace+30.
;
; 10*x uses add hl,hl / rl de.  Cursor via ld de,sp+n / ld hl,(de).

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_digits


.m32__dtoa_digits
    ld a,c
    or a
    ret Z

    ld a,d
    rra
    rra
    rra
    rra
    and 00fh
    add a,'0'

    push bc
    push de
    push hl                         ; CALL+3 pushes: work at SP+8
    ld c,a
    ld de,sp+38                     ; work+30
    ld hl,(de)
    ld (hl+),c                      ; *p++
    ld (de),hl
    pop hl
    pop de                          ; counts remain stacked

    ld a,d
    and 00fh
    ld d,a

    push de
    push hl
    add hl,hl
    rl de                           ; 2x
    add hl,hl
    rl de                           ; 4x
    pop bc
    add hl,bc
    pop bc
    ld a,c
    adc a,e
    ld e,a
    ld a,b
    adc a,d
    ld d,a                          ; 5x
    add hl,hl
    rl de                           ; 10x

    pop bc                          ; counts
    dec c
    dec b
    jp NZ,m32__dtoa_digits

    scf
    ret
