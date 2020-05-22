;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2020 May
;
;-------------------------------------------------------------------------
;  asm_f24_int - z80 half floating to int
;-------------------------------------------------------------------------
;
;  unpacked format: sign in d[7], exponent in e, mantissa in hl
;  return normalized result also in unpacked format
;
;  return int in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN  l_neg_hl

PUBLIC asm_f24_2int
PUBLIC asm_f24_2uint

; Convert floating point number to int
.asm_f24_2int
.asm_f24_2uint
    ld a,e                      ;Holds exponent
    and a
    jr Z,izero                  ;exponent was 0, return 0
    cp $7e + 16
    jp NC,imax                  ;number too large
.iloop
    srl h                       ;fill with 0
    rr l
    inc a
    cp $7e + 16
    jr NZ,iloop
    rl d                        ;check sign bit
    call C,l_neg_hl
    ret

.izero
    ld hl,0
    ret

.imax
    ld hl,0FFh
    ret
