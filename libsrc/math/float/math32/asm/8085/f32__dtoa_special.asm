;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_special — inf / nan / zero workspace
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_special


.m32__dtoa_special
    ; enter : a = fpclassify (1 zero, 2 nan, 3 inf)
    ;        hl = buffer_dst *
    ;
    ; exit  : carry set if inf/nan (buffer holds a NUL-terminated string)
    ;         carry reset if zero: buffer is "0." and HL points after '.'
    ;
    ; uses  : af, de, hl

    dec a
    jp Z,zero

    ld de,nan_s
    dec a
    jp Z,string
    ld de,inf_s

.string
    ld a,(de)
    ld (hl+),a                      ; *p++
    inc de
    or a
    jp NZ,string
    dec hl
    scf
    ret

.zero
    ld (hl),'0'
    inc hl
    ld (hl),'.'
    inc hl
    or a                            ; NC
    ret

.nan_s
    defm "nan"
    defb 0

.inf_s
    defm "inf"
    defb 0
