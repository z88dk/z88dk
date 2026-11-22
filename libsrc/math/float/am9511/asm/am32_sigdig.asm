;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, August 2020
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_sigdig

asm_am9511_sigdig:

   ; exit  : b = number of significant hex digits in double representation
   ;         c = number of significant decimal digits in double representation
   ;
   ; uses  : bc

   ld bc,$0607
   ret
