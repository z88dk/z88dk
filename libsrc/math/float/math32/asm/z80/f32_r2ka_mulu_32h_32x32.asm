;
;  feilipu, 2023 August / 2026 July (trunc high-half, same as pure Z80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF  __CPU_RABBIT__

SECTION code_clib
SECTION code_fp_math32

EXTERN l_mulu_32_16x16

PUBLIC m32_mulu_32h_32x32

;------------------------------------------------------------------------------
;
; multiplication of two 32-bit numbers into the high 32 bits of 64-bit product
;
; enter : dehl  = 32-bit multiplicand  = x   x1x0
;         dehl' = 32-bit multiplier    = y   y1y0
;
; exit  : dehl  = 32-bit product = high half of y * x
;         carry reset
;
; uses  : af, bc, de, hl, bc', de', hl'
;
; Truncated high-half — same structure as f32_z80_mulu_32h_32x32:
;   omit y0*x0; keep y1*x0, y0*x1, y1*x1 and carries from cross low halves.
;   Max |err| vs true (x*y)>>32 is 1.
;
; 16×16→32: l_mulu_32_16x16 (dehl = hl * de).  On r2ka/r4k this is the
; unsigned wrapper around the signed hardware MUL.
;
; Mid-low sticky (cheap, near-zero mean bias):
;   After z1 += low(y0*x1), if bit15 of z1 is set, set bit0 of final high
;   half (OR).  Host (float mants): max|err|=1, exact ~73%, bias ~0
;   (bare trunc exact ~75%, bias ~−0.25).
;
;------------------------------------------------------------------------------

.m32_mulu_32h_32x32

    push de                     ; x1
    push de                     ; x1
    exx

    pop bc                      ; x1
    push de                     ; y1
    push bc                     ; x1

    push hl                     ; y0
    push de                     ; y1 → z1 slot

    exx
    ld d,h
    ld e,l                      ; de = x0
    ld hl,0
    ex (sp),hl                  ; hl = y1, (sp) = z1 = 0

    ; --- y1 * x0 ---  dehl = hl * de  with hl=y1, de=x0
    call l_mulu_32_16x16

    pop bc                      ; z1 = 0
    add hl,bc
    ld b,h
    ld c,l

    ld hl,0
    adc hl,de
    ex de,hl
    exx                         ; de'bc' = z2 z1

    pop de                      ; y0
    pop hl                      ; x1

    ; --- y0 * x1 ---  dehl = hl * de  with hl=x1, de=y0
    call l_mulu_32_16x16

    push de
    push hl
    exx

    pop hl
    add hl,bc                   ; z1 += low(y0*x1)
    ld a,h                      ; sticky: bit15 of mid-low sum

    pop hl
    adc hl,de                   ; z2 += high(y0*x1) + CF
    ex de,hl

    ld bc,0
    rl c                        ; c = z3

    ; park sticky in b7 (b was 0)
    and 080h
    ld b,a                      ; b7 = sticky, c = z3

    exx                         ; bc' = sticky:z3, de' = z2

    pop de                      ; y1
    pop hl                      ; x1

    ; --- y1 * x1 ---
    call l_mulu_32_16x16

    push de
    push hl
    exx

    pop hl
    add hl,de                   ; + z2
    ex de,hl                    ; de = z2

    pop hl                      ; high(y1*x1)
    ; bc = sticky<<8 | z3  — only c must enter adc as z3
    ld a,b                      ; sticky flag
    ld b,0                      ; bc = z3
    adc hl,bc                   ; z3

    ex de,hl                    ; de = z3, hl = z2  → DEHL high product

    ; sticky: OR bit0 of L if mid-low bit15 was set
    and 080h
    jr Z,r2ka_h32_done
    set 0,l

.r2ka_h32_done
    or a                        ; NC
    ret

ENDIF
