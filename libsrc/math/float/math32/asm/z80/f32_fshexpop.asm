;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fshexpop — hex pop helper
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_dhexpop

EXTERN m32_fsmin

m32_dhexpop:

   ; strtod helper
   ;
   ; create double from mantissa on stack
   ;
   ; enter : stack = mantissa, ret
   ;
   ; exit  : DEHL'= double
   ;
   ; uses  : af, bc', de', hl'

    exx
    pop bc                      ; my return
    pop hl                      ; sdcc_float
    pop de
    push bc

    ld a,$7f

.normmant
    bit 7,e
    jr NZ,normdone

    add hl,hl                   ; sla hl
    rl e

    dec a
    jp Z,m32_fsmin              ; safety net, in case something is borked

    jr normmant

.normdone
    ld d,a
    sla e
    srl d
    rr e

    exx
    ret

