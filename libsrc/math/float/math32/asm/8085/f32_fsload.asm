;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085: load float at HL into DEHL

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsload

.m32_fsload
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)                   ; last byte: no post-inc (HL → bc next)
    ld hl,bc
    ret
