;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; Coefficients for exp()
;-------------------------------------------------------------------------
;
;   float coeff[] =
;   {
;       1.0000000000e+00,
;       6.9314718056e-01,
;       2.4022650695e-01,
;       5.5504108945e-02,
;       9.6181261779e-03,
;       1.3333710529e-03,
;       1.5399104432e-04,
;       1.5327675257e-05,
;       1.2485143336e-06,
;       1.3908092221e-07,
;    };
;
;-------------------------------------------------------------------------

SECTION rodata_clib

PUBLIC _coeff_exp

._coeff_exp
DEFQ 0x3F800000;       1.0000000000e+00
DEFQ 0x3F317218;       6.9314718056e-01
DEFQ 0x3E75FDF0;       2.4022650695e-01
DEFQ 0x3D635847;       5.5504108945e-02
DEFQ 0x3C1D9558;       9.6181261779e-03
DEFQ 0x3AAEC482;       1.3333710529e-03
DEFQ 0x392178A8;       1.5399104432e-04
DEFQ 0x378093EF;       1.5327675257e-05
DEFQ 0x35A792A0;       1.2485143336e-06
DEFQ 0x34155646;       1.3908092221e-07
