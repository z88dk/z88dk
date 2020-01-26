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

PUBLIC lut_write

;------------------------------------------------------------------------------
;
; Write RC2014 LUT Module
;
; enter  : hl = 16-bit address or h = 8-bit row Y, l = 8-bit column X
;

.lut_write

    push bc                                 ; 11 preserve BC
    ld b,h                                  ; 4 operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH             ; 7 operand latch address
    out (c),l                               ; 12 operand X from E
    pop bc                                  ; 10 restore BC
    ret                                     ; 10

ENDIF
ENDIF
