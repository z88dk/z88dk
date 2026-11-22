;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_digits — generate decimal digits (stack-only)
;-------------------------------------------------------------------------
;
; DEHL = mantissa (top 4 bits of D = next decimal digit).
; B = digits to generate, C = remaining significant digits.
; Buffer pointer at workspace+30.
;
; Carry set if all requested digits were written.  Carry reset if C
; ran out first (B leftover).

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

    push bc                         ; counts
    push de
    push hl                         ; CALL+3 pushes: work at SP+8
    ld e,a
    ld hl,sp+38                     ; work+30
    ld a,(hl+)
    ld d,(hl)
    ld l,a
    ld h,d
    ld (hl+),e                      ; *p++
    ld bc,hl
    ld hl,sp+38
    ld (hl+),c
    ld (hl),b
    pop hl
    pop de                          ; DEHL = mantissa; counts still stacked

    ld a,d
    and 00fh
    ld d,a

    ; 10*x = 2*(4*x + x).  Counts remain under this orig snapshot.
    push de
    push hl
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
    pop bc
    add hl,bc
    pop bc
    ld a,c
    adc a,e
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a                          ; DEHL = 10x

    pop bc                          ; counts
    dec c
    dec b
    jp NZ,m32__dtoa_digits

    scf
    ret
