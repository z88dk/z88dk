;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; Coefficients for sinf()
;-------------------------------------------------------------------------
;
;   float coeff_a[] =
;   {
;        0.1357884e8,
;       -0.49429081e7,
;        0.440103053e6,
;       -0.138472724e5,
;        0.145968841e3
;   };
;   
;   float coeff_b[] =
;   {
;        0.864455865e7,
;        0.408179225e6,
;        0.946309610e4,
;        0.132653491e3,
;        1.0
;   };
;
;-------------------------------------------------------------------------

SECTION rodata_fp_math32

PUBLIC _m32_coeff_sin_a, _m32_coeff_sin_b

._m32_coeff_sin_a
DEFQ 0x4B4F3258;        0.1357884e8
DEFQ 0xCA96D878;       -0.49429081e7
DEFQ 0x48D6E4E2;        0.440103053e6
DEFQ 0xC6585D17;       -0.138472724e5
DEFQ 0x4311F806;        0.145968841e3

._m32_coeff_sin_b
DEFQ 0x4B03E7CF;        0.864455865e7
DEFQ 0x48C74E67;        0.408179225e6
DEFQ 0x4613DC62;        0.946309610e4
DEFQ 0x4304A74B;        0.132653491e3
DEFQ 0x3F800000;        1.0

