;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; Coefficients for logf()
;-------------------------------------------------------------------------
;
;   float coeff[] =
;   {
;        0.0000000000,    /* a0 */
;        0.9999964239,    /* a1 */
;       -0.4998741238,    /* a2 */
;        0.3317990258,    /* a3 */
;       -0.2407338084,    /* a4 */
;        0.1676540711,    /* a5 */
;       -0.0953293897,    /* a6 */
;        0.0360884937,    /* a7 */
;       -0.0064535442,    /* a8 */
;    };
;
;-------------------------------------------------------------------------

SECTION rodata_fp_math32

PUBLIC _m32_coeff_log

._m32_coeff_log
DEFQ 0x00000000;        0.0000000000,    /* a0 */
DEFQ 0x3F7FFFC4;        0.9999964239,    /* a1 */
DEFQ 0xBEFFEF80;       -0.4998741238,    /* a2 */
DEFQ 0x3EA9E190;        0.3317990258,    /* a3 */
DEFQ 0xBE7682EC;       -0.2407338084,    /* a4 */
DEFQ 0x3E2BAD82;        0.1676540711,    /* a5 */
DEFQ 0xBDC33C0E;       -0.0953293897,    /* a6 */
DEFQ 0x3D13D187;        0.0360884937,    /* a7 */
DEFQ 0xBBD37841;       -0.0064535442,    /* a8 */
