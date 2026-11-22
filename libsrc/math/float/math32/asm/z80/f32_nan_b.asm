;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_nan_b — strtod nan(...) helper
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_nan_b

EXTERN m32_derror_einval_zc

m32_nan_b:

    ; strtod() helper function
    ; return nan(...) given pointer to buffer at '('
    ;
    ; enter : hl = char *buff
    ;
    ; exit  : hl = char *buff (moved past nan argument)
    ;         DEHL'= nan(...)
    ;
    ; uses  : af, hl, bc', de', hl'

    ld a,(hl)

    cp '('
    jp NZ, m32_derror_einval_zc

    inc hl

loop:
    ld a,(hl)
    or a
    jp Z, m32_derror_einval_zc
    
    inc hl
    cp ')'
    jp Z, m32_derror_einval_zc

    jr loop

