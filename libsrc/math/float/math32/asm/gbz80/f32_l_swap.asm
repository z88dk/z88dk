;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 l_f32_swap — sccz80 float operand swap
;-------------------------------------------------------------------------
;
; Entry: DEHL = right; stack = ret, left.LSW, left.MSW
; Exit:  DEHL = left;  stack = ret, right.LSW, right.MSW

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_swap


.l_f32_swap
    pop bc                          ; BC = return
    push de
    push hl                         ; SP: right(4), left(4)
    push bc                         ; SP: ret, right, left
    ld hl,sp+2                      ; &right
    push hl
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    ld hl,sp+6                      ; &left
    ld b,4
.swloop
    ld a,(de)
    ld c,a                          ; right byte (ld (de),r is A-only)
    ld a,(hl)                       ; left byte
    ld (de+),a                      ; left → right
    ld (hl+),c                      ; right → left
    dec b
    jp NZ,swloop
    pop bc                          ; BC = ret
    pop hl                          ; left LSW
    pop de                          ; left MSW → DEHL = left
    push bc                         ; ret
    ret
