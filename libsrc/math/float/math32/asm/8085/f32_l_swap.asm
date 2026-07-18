;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 l_f32_swap — sccz80 float operand swap
;
; Entry: DEHL = right; stack = ret, left.LSW, left.MSW
; Exit:  DEHL = left;  stack = ret, right.LSW, right.MSW
;
; Z80 stock (pop af / ex de,hl / ex (sp),hl / …) fails on 8085 ticks
; for that exact sequence. This version block-swaps the two floats.
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_swap


.l_f32_swap
    pop bc                          ; BC = return
    ; DEHL = right; SP: left (4)
    push de
    push hl                         ; SP: right(4), left(4)
    ; Swap the two 4-byte blocks
    push bc                         ; free BC; SP: ret, right, left
    ld de,sp+2                      ; &right
    ld hl,sp+6                      ; &left
    ld b,4
.swloop
    ld a,(de)
    ld c,a
    ld a,(hl)
    ld (de),a
    ld a,c
    ld (hl),a
    inc de
    inc hl
    dec b
    jp NZ,swloop
    pop bc                          ; BC = ret
    ; SP: left(4), right(4)
    pop hl                          ; left LSW
    pop de                          ; left MSW → DEHL = left
    ; SP: right(4)
    push bc                         ; ret
    ret
