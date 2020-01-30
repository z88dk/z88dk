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
SECTION code_math

PUBLIC l_mulu_de

;------------------------------------------------------------------------------
;
; Hardware mulu_16_8x8 using RC2014 LUT Module
;
; enter : d = 8-bit multiplicand Y
;         e = 8-bit multiplicand X
;
; exit  : de = 16-bit product Z
;

defc l_mulu_de = m32_lut_mulu_de

ENDIF
ENDIF
