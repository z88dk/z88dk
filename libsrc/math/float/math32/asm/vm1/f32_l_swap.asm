;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; vm1 l_f32_swap — sccz80 float operand swap
;-------------------------------------------------------------------------
;
; Entry: DEHL = right; stack = ret, left.LSW, left.MSW
; Exit:  DEHL = left;  stack = ret, right.LSW, right.MSW
;
; Word swap via LHLX / SHLX. Frame address through HL (no LDSI).

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_swap


.l_f32_swap
    pop bc                          ; BC = return
    push de
    push hl                         ; SP: right(4), left(4)
    push bc                         ; SP: ret, right LSW, right MSW, left LSW, left MSW

    ; swap LSW (sp+2 <-> sp+6)
    ld hl,2
    add hl,sp
    ex de,hl
    ld hl,(de)
    ld b,h
    ld c,l                          ; BC = right LSW
    ld hl,6
    add hl,sp
    ex de,hl
    ld hl,(de)                      ; HL = left LSW
    ex de,hl
    ld hl,2
    add hl,sp
    ex de,hl
    ld (de),hl                      ; right LSW := left LSW
    ld h,b
    ld l,c
    ex de,hl
    ld hl,6
    add hl,sp
    ex de,hl
    ld (de),hl                      ; left LSW := old right LSW

    ; swap MSW (sp+4 <-> sp+8)
    ld hl,4
    add hl,sp
    ex de,hl
    ld hl,(de)
    ld b,h
    ld c,l
    ld hl,8
    add hl,sp
    ex de,hl
    ld hl,(de)
    ex de,hl
    ld hl,4
    add hl,sp
    ex de,hl
    ld (de),hl
    ld h,b
    ld l,c
    ex de,hl
    ld hl,8
    add hl,sp
    ex de,hl
    ld (de),hl

    pop bc                          ; BC = ret
    pop hl                          ; left LSW
    pop de                          ; left MSW → DEHL = left
    push bc
    ret
