;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_round — round the extra generated digit
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_round


.m32__dtoa_round
    ; HL = buffer_dst * (one past last generated digit, which is the
    ;      rounding digit).  Carry slot is a leading '0' before the
    ;      first digit.
    ;
    ; uses  : af, hl

    dec hl                          ; rounding digit
    ld a,(hl)
    cp '5'
    ret C                           ; round down

    push hl

.loop_round
    dec hl
    ld a,(hl)

    cp '.'
    jp Z,loop_round

    ld (hl),'0'

    cp '9'
    jp Z,loop_round

    inc a
    ld (hl),a

    pop hl
    ret
