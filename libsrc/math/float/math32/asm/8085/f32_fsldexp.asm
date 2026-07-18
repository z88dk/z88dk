;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsldexp / m32_dmulpow2 — x * 2^n
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmin

PUBLIC m32_dmulpow2
PUBLIC m32_fsldexp_callee
PUBLIC _m32_ldexpf


.m32_dmulpow2
    ld b,h
    ld c,l
    jp pow2


; stack = int16_t pw2, float x, ret
._m32_ldexpf
.m32_fsldexp_callee
    pop bc                          ; ret
    pop hl                          ; x.HL
    pop de                          ; x.DE
    ; SP: pw2
    push bc                         ; ret
    push de
    push hl                         ; x : SP = x.HL, x.DE, ret, pw2
    ld hl,6
    add hl,sp
    ld c,(hl)
    inc hl
    ld b,(hl)                       ; BC = pw2
    pop hl
    pop de                          ; DEHL = x
    ; SP: ret, pw2
    push de
    push hl                         ; save x
    pop hl
    pop de                          ; DEHL = x
    pop hl                          ; ret
    ; SP: pw2
    inc sp
    inc sp                          ; drop pw2
    push hl                         ; ret
    ; DEHL = x, BC = pw2; use C as power addend
    ld a,c
    ld c,a

.pow2
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    or a
    jp Z,zero_legal

    ld a,e
    rra
    ld e,a

    ld a,d
    inc a
    jp Z,ldexp_pack

    ld a,d
    add a,c
    jp C,ldexp_wrap

    or a
    jp Z,ldexp_uflow
    ld d,a
    inc a
    jp Z,ldexp_oflow

.ldexp_pack
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    or a
    ret

.ldexp_wrap
    ld a,c
    rla
    jp C,ldexp_uflow

.ldexp_oflow
    ld a,e
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    ret

.ldexp_uflow
    ld a,e
    add a,a
    ld d,0
    xor a
    rra
    ld d,a
    ld e,0
    ld hl,0
    jp m32_fsmin

.zero_legal
    ld de,0
    ld hl,0
    ld a,0
    rra
    ld d,a
    ret
