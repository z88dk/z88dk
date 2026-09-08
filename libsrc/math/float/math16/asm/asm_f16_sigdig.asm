;
;  feilipu, 2020
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  Portable: significant digit counts for half-float formatting.
;

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f16_sigdig

.asm_f16_sigdig
   ; exit  : b = significant hex digits in half float representation
   ;         c = significant decimal digits in half float representation
   ;
   ; uses  : bc

   ld bc,$0304
   ret
