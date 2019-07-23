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
;   float coeff_a[] =
;   {
;       33.05861847399,
;       58.655751569,
;       32.3907948562,
;       5.853195211263,
;       0.1952374193623,
;       -.002434603300441
;   };
;
;   float coeff_b[] =
;   {
;       33.05861847399,
;       69.67529105952,
;       49.00434821822,
;       12.97557886271,
;       1.0
;   };
;
;-------------------------------------------------------------------------

SECTION rodata_fp_math32

PUBLIC _m32_coeff_atan_a, _m32_coeff_atan_b

._m32_coeff_atan_a
DEFQ 0x42043C06;       33.05861847399
DEFQ 0x426A9F7D;       58.655751569
DEFQ 0x4201902D;       32.3907948562
DEFQ 0x40BB4D60;       5.853195211263
DEFQ 0x3E47EC51;       0.1952374193623
DEFQ 0xBB1F8DDE;       -.002434603300441

._m32_coeff_atan_b
DEFQ 0x42043C06;       33.05861847399
DEFQ 0x428B59C0;       69.67529105952
DEFQ 0x42440474;       49.00434821822
DEFQ 0x414F9BF9;       12.97557886271
DEFQ 0x3F800000;       1.0

