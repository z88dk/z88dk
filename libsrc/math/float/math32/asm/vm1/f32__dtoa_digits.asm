;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_digits — generate decimal digits (vm1)
;-------------------------------------------------------------------------
;
; Cursor via LHLX/SHLX.  No rl de (that encoding is sub hl,de).
; Never pop af of unknown contents.

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
    ld hl,38
    add hl,sp
    ex de,hl
    ld hl,(de)
    ld (hl),c
    inc hl
    ld (de),hl
    pop hl
    pop de                          ; counts remain stacked

    ld a,d
    and 00fh
    ld d,a

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
    ld d,a

    pop bc
    dec c
    dec b
    jp NZ,m32__dtoa_digits

    scf
    ret
