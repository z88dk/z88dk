;
;  feilipu, 2020 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; Coefficients for sinf() and cosf()
;-------------------------------------------------------------------------

SECTION rodata_fp_math32

PUBLIC _m32_coeff_sin, _m32_coeff_cos

; y = (((-1.9515295891E-4 * z + 8.3321608736E-3) * z - 1.6666654611E-1) * z + 0.0)

._m32_coeff_sin
DEFQ 0x00000000;        0.0
DEFQ 0xBE2AAAA3;       -1.6666654611e-1
DEFQ 0x3C08839E;        8.3321608736e-3
DEFQ 0xB94CA1F9;       -1.9515295891e-4

; y = ((( 2.443315711809948E-005 * z - 1.388731625493765E-003) * z + 4.166664568298827E-002) * z + 0.0) * z + 0.0;

._m32_coeff_cos
DEFQ 0x00000000;        0.0
DEFQ 0x00000000;        0.0
DEFQ 0x3D2AAAA5;        4.166664568298827e-2
DEFQ 0xBAB6061A;       -1.388731625493765e-3
DEFQ 0x37CCF5CE;        2.443315711809948e-5

