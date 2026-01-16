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

SECTION code_fp_am9511

PUBLIC asm_am9511_const_pzero
PUBLIC asm_am9511_const_nzero
PUBLIC asm_am9511_const_one
PUBLIC asm_am9511_const_1_3
PUBLIC asm_am9511_const_pi
PUBLIC asm_am9511_const_pinf
PUBLIC asm_am9511_const_ninf
PUBLIC asm_am9511_const_pnan
PUBLIC asm_am9511_const_nnan

.asm_am9511_const_pzero
    ld de,0
    ld h,e
    ld l,e
    ret

.asm_am9511_const_nzero
    ld de,$8000
    ld h,e
    ld l,e
    ret

.asm_am9511_const_one
    ld de,$3f80
    ld hl,$0000
    ret

.asm_am9511_const_1_3
    ld de,$3eaa
    ld hl,$aaab
    ret

.asm_am9511_const_pi
    ld de,$4049
    ld hl,$0fdb
    ret

.asm_am9511_const_pinf
    ld de,$7f80
    ld hl,0
    ret

.asm_am9511_const_ninf
    ld de,$ff80
    ld hl,0
    ret

.asm_am9511_const_pnan
    ld de,$7fff
    ld h,e
    ld l,e
    ret

.asm_am9511_const_nnan
    ld de,$ffff
    ld h,e
    ld l,e
    ret

