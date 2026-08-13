;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; Coefficients for atanf()
;-------------------------------------------------------------------------
;
;  Approximation of f(x) = atan(x)
;  with weight function g(x) = atan(x)
;  on interval [ 0, 1 ]
;  with a polynomial of degree 7.
;
; float f(float x)
; {
;    float u = +5.3387679e-2f;
;    u = u * x + -2.2568632e-1f;
;    u = u * x + +3.2087456e-1f;
;    u = u * x + -3.4700353e-2f;
;    u = u * x + -3.2812673e-1f;
;    u = u * x + -3.5815786e-4f;
;    u = u * x + +1.0000081e+0f;
;    return u * x + 4.2012834e-19f;
; }
;
;-------------------------------------------------------------------------

SECTION rodata_clib
SECTION rodata_fp_math32

PUBLIC _m32_coeff_atan

._m32_coeff_atan
DEFQ 0x00000000;       +4.2012834e-19 or approximately 0.0
DEFQ 0x3F800000;       +1.0000081e+0  or approximately 1.0
DEFQ 0xB9BBC722;       -3.5815786e-4
DEFQ 0xBEA8003A;       -3.2812673e-1
DEFQ 0xBD0E21F5;       -3.4700353e-2
DEFQ 0x3EA449AC;       +3.2087456e-1
DEFQ 0xBE671A51;       -2.2568632e-1
DEFQ 0x3D5AAD0A;       +5.3387679e-2

