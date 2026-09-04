;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; 8085 l_f32_swap — sccz80 float operand swap
;-------------------------------------------------------------------------
;
; Entry: DEHL = right; stack = ret, left.LSW, left.MSW
; Exit:  DEHL = left;  stack = ret, right.LSW, right.MSW
;
; Z80 stock (pop af / ex de,hl / ex (sp),hl / …) fails on 8085 ticks
; for that exact sequence. This version block-swaps the two floats.

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_swap


.l_f32_swap
    pop bc                          ; BC = return
    ; DEHL = right; SP: left (4)
    push de
    push hl                         ; SP: right(4), left(4)
    push bc                         ; free BC; SP: ret, right, left
    ; Swap two words with ld hl,(de) / ld (de),hl
    ld de,sp+2
    ld hl,(de)                      ; right LSW
    ld bc,hl
    ld de,sp+6
    ld hl,(de)                      ; left LSW
    ld de,sp+2
    ld (de),hl
    ld hl,bc
    ld de,sp+6
    ld (de),hl
    ld de,sp+4
    ld hl,(de)                      ; right MSW
    ld bc,hl
    ld de,sp+8
    ld hl,(de)                      ; left MSW
    ld de,sp+4
    ld (de),hl
    ld hl,bc
    ld de,sp+8
    ld (de),hl
    pop bc                          ; BC = ret
    pop hl                          ; left LSW
    pop de                          ; left MSW → DEHL = left
    push bc                         ; ret
    ret
