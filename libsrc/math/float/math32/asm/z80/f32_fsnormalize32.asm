;
;  feilipu, 2026 August
;  ped7g, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize32 - z80 / z180 / z80n unpacked 32-bit normalisation
;-------------------------------------------------------------------------
;
;  unpacked: mantissa=dehl, exponent in b, sign in c[7]
;  DEHL is already add hl,hl / rl de layout.
;
;  Byte scan; residual merge loop (add hl,hl / rl de).
;  z80asm rl de → rl e; rl d, so SF is already D.7 (no or d needed).

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize32


.m32_fsnormalize32
    ld a,d
    or a
    ret m                       ; already normalised
    jr nz,need_shift

    ld a,e
    or a
    jr nz,need8

    ld a,h
    or a
    jr nz,need16

    ld a,l
    or a
    jr z,normzero

    ; leading in L → +24
    ld d,l
    ld e,0
    ld hl,0
    ld a,b
    sub 24
    ld b,a
    jr c,normzero
    jr bitshift_check

.need16
    ex de,hl                    ; DE ← old HL, HL ← 0 (old DE was 0)
    ld a,b
    sub 16
    ld b,a
    jr c,normzero
    jr bitshift_check

.need8
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,b
    sub 8
    ld b,a
    jr c,normzero
    ; fall through

.bitshift_check
    ld a,d
    or a
    ret m                       ; normalised after byte align only
    jr z,normzero

    ; ---------------------------------------------------------------
    ; Residual: count in temp B; exp+sign on stack
    ; rl de ends with rl d → SF = D.7 (Z80)
    ; ---------------------------------------------------------------

.need_shift
    push bc                     ; exp + sign
    ld b,0
.shift_loop
    inc b
    add hl,hl
    rl de
    jp p,shift_loop             ; D.7 not set yet

    ld a,b                      ; residual
    pop bc                      ; B = exp, C = sign
    cpl
    inc a                       ; −residual
    add a,b
    jr nc,normzero
    ld b,a
    ret

.normzero
    xor a
    ld b,a
    ld d,a
    ld e,a
    ld h,a
    ld l,a
    ret
