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
; asm_am9511_ldexp - 8085 load exponent
;-------------------------------------------------------------------------
;
;   float ldexpf (float x, int16_t pw2)
;   {
;       union float_long fl;
;       int32_t e;
;
;       fl.f = x;
;
;       e = (fl.l >> 23) & 0x000000ff;
;       e += pw2;
;       fl.l = ((e & 0xff) << 23) | (fl.l & 0x807fffff);
;
;       return(fl.f);
;   }
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN asm_am9511_zero, asm_am9511_max

PUBLIC asm_am9511_ldexp_callee


; float ldexpf (float x, int16_t pw2);
.asm_am9511_ldexp_callee
    ; evaluation of fraction and exponent
    ;
    ; enter : stack = int16_t pw2, float x, ret
    ;
    ; exit  : dehl  = 32-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld de,sp+4                  ; point to mantissa and exponent
    ld hl,(de)

    add hl,hl                   ; get the exponent and mantissa
    inc h
    dec h
    jp Z,zero                   ; return IEEE signed zero

    ld de,sp+6
    ld a,(de)                   ; (int8_t)pw2
    add h
    ld h,a                      ; exponent returned

    jp C,max                    ; exponent is overflowed
    jp Z,zero                   ; return IEEE underflow zero

    dec de
    ld a,(de)                   ; get original sign and exponent
    rla                         ; capture sign
    ld a,h
    rra                         ; new sign and exponent
    ld d,a

    ld a,l                      ; new exponent and mantissa
    rra
    ld e,a

    pop bc                      ; pop return
    pop hl                      ; valid old mantissa
    pop af                      ; discard old mantissa and exponent
    pop af                      ; discard old pw2
    push bc                     ; replace return

    ret

.zero
    pop bc                      ; pop return
    pop hl                      ; valid mantissa
    pop de                      ; old mantissa and exponent
    pop af                      ; discard pw2
    push bc                     ; replace return
    jp asm_am9511_zero          ; return IEEE signed ZERO in DEHL

.max
    pop bc                      ; pop return
    pop hl                      ; valid mantissa
    pop de                      ; old mantissa and exponent
    pop af                      ; discard pw2
    push bc                     ; replace return
    jp asm_am9511_max           ; return IEEE signed infinity in DEHL
