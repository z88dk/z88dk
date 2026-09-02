;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fssigdig — significant hex/decimal digit counts
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fssigdig

m32_fssigdig:

   ; exit  : b = number of significant hex digits in double representation
   ;         c = number of significant decimal digits in double representation
   ;
   ; uses  : bc

   ld bc,$0607
   ret
