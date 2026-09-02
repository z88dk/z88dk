;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_sgnabs — sign and absolute value
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_sgnabs

    ; enter : dehl' = x = floating point number
    ;
    ; exit  : dehl' = |x|
    ;         a  = sgn(x) = 1 if negative, 0 otherwise
    ;
    ; uses  : af

.m32__dtoa_sgnabs
    exx
    ld a,d
    res 7,d

    exx
    rlca
    and $01
    ret

