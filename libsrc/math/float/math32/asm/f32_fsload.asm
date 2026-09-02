;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8080-compatible (shared: 8080 / 8085 / gbz80 / z80)

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
