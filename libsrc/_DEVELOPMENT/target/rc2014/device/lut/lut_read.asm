;
;  feilipu, 2020 January
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; Using RC2014 LUT Module
;
;------------------------------------------------------------------------------

IF __CPU_Z80__

INCLUDE "config_private.inc"

IF __IO_LUT_MODULE_AVAILABLE > 0

SECTION code_driver

PUBLIC lut_read

;------------------------------------------------------------------------------
;
; Read RC2014 LUT Module
;
; exit  : hl = 16-bit result
;

.lut_read

    push bc                                 ; 11 preserve BC
    ld c,__IO_LUT_RESULT_MSB                ; 7 result MSB address
    in h,(c)                                ; 12 result MSB to H
    dec c                                   ; 4 result LSB address
    in l,(c)                                ; 12 result LSB to L
    pop bc                                  ; 10 restore BC
    ret                                     ; 10

ENDIF
ENDIF
