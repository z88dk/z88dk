;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_sgnabs — sign and absolute value (stack-only, DEHL — vm1)
;-------------------------------------------------------------------------
;
; Z80 contract uses DEHL'.  Stack-only cores keep the float in DEHL.

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_sgnabs


.m32__dtoa_sgnabs
    ; enter : dehl = x
    ; exit  : dehl = |x|
    ;            a = 1 if negative, 0 otherwise
    ; uses  : af

    ld a,d
    rla                             ; C = sign
    sbc a,a
    and 1                           ; A = 1 if negative
    push af
    ld a,d
    and 07fh
    ld d,a
    pop af
    ret
