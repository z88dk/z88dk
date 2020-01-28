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
    push bc                     ; 11 preserve BC
    ld b,h                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),l                   ; 12 operand X from L
    dec c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
    dec c                       ; 4  result LSB address
    in l,(c)                    ; 12 result Z LSB to L
    pop bc                      ; 10 restore BC

ENDIF
ENDIF
