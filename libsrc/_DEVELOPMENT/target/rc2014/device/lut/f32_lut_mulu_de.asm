;
;  feilipu, 2020 January
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; REPLICATION for Z80 of:
; Z180 MLT DE and Z80-ZXN MUL DE
; using RC2014 LUT Module
;
;------------------------------------------------------------------------------

IF __CPU_Z80__

INCLUDE "config_private.inc"

IF __IO_LUT_MODULE_AVAILABLE > 0

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_lut_mulu_de
PUBLIC m32_z80_mulu_de

;------------------------------------------------------------------------------
;
; Hardware mulu_16_8x8 using RC2014 LUT Module
;
; enter : d = 8-bit multiplicand Y
;         e = 8-bit multiplicand X
;
; exit  : de = 16-bit product Z
;

.m32_lut_mulu_de

    push bc                                 ; 11 preserve BC
    ld b,d                                  ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH             ; 7  operand latch address
    out (c),e                               ; 12 operand X from E
    dec c                                   ; 4  result MSB address
    in d,(c)                                ; 12 result Z MSB to D
    dec c                                   ; 4  result LSB address
    in e,(c)                                ; 12 result Z LSB to E
    pop bc                                  ; 10 restore BC
    ret                                     ; 10

defc m32_z80_mulu_de = m32_lut_mulu_de

ENDIF
ENDIF
