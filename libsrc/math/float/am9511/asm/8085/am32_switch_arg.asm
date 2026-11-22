;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_switch_arg


.asm_switch_arg
    ; Switch arguments
    ;
    ; Entry:
    ; Stack: left, right, ret1, ret0
    ;
    ; Exit:
    ; Stack: right, left, ret1
    ;
    ; Uses a, bc, de, hl

    ld de,sp+8          ; left
    ex de,hl
    ld de,sp+4          ; right
    ld b,4
.loop
    ld c,(hl)
    ld a,(de)
    ex de,hl
    ld (hl),c
    ld (de),a
    inc hl
    inc de
    dec b
    jp NZ,loop
    ret

