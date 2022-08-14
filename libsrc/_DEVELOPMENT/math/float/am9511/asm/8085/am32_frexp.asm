;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------
; asm_am9511_frexp - 8085 fraction and exponent
;-------------------------------------------------------------------------
;
;   float frexpf (float x, int *pw2)
;   {
;       union float_long fl;
;       int8_t i;
;
;       fl.f = x;
;       /* Find the exponent (power of 2) */
;       i  = ( fl.l >> 23) & 0x000000ff;
;       i -= 0x7e;
;       *pw2 = i;
;       fl.l &= 0x807fffff; /* strip all exponent bits */
;       fl.l |= 0x3f000000; /* mantissa between 0.5 and 1 */
;       return(fl.f);
;   }
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_frexp_callee


; float frexpf (float x, int *pw2);
.asm_am9511_frexp_callee
    ; evaluation of fraction and exponent
    ;
    ; enter : stack = float *pw2, float x, ret
    ;
    ; exit  : dehl  = 32-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld de,sp+4                  ; point to mantissa and exponent
    ld hl,(de)

    add hl,hl                   ; get the exponent and mantissa
    ld a,h
    or a
    jp Z,zero

    ld h,$7e                    ; remove exponent excess (bias-1)
    sub h                       ; mantissa between 0.5 and 1

.zero
    ld de,sp+6                  ; point to (int8_t*)pw2
    ex de,hl
    ld c,(hl)                   ; get pw2
    inc hl
    ld b,(hl)
    ex de,hl

    ld (bc),a                   ; and store in pw2
    inc bc
    rlca
    sbc a
    ld (bc),a

    ld de,sp+5                  ; point to original sign and exponent
    ld a,(de)                   ; get sign and exponent
    rla                         ; capture sign
    ld a,h
    rra                         ; new sign and exponent
    ld d,a

    ld a,l                      ; new exponent and mantissa
    rra
    ld e,a

    pop bc                      ; pop return
    pop hl                      ; valid mantissa
    pop af                      ; discard old mantissa and exponent
    pop af                      ; discard (int8_t*)pw2
    push bc                     ; replace return

    ret                         ; return IEEE DEHL fraction
