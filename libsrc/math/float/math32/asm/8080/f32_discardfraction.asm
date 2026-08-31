;
;  feilipu, 2026 July / August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8080 m32_discardfraction — rl de expanded through A.
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_discardfraction

.m32_discardfraction
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a                          ; D = exp, C = sign (rla does not set Z)
    push af
    ld a,d
    or a
    jp Z,zero_legal
    pop af

    ld a,d
    push af
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    pop af

    sub $7f
    jr C,return_zero

    inc a
    cp 24
    jr C,mask_frac
    or a
    ret

.mask_frac
    ld b,a                      ; n bits to keep
    push de
    push hl
    push de
    push hl

    ld hl,0
    ld c,0
.sr
    scf
    ld a,c
    rra
    ld c,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec b
    jr NZ,sr

    ex de,hl                    ; DE=mask15
    ld a,c                      ; A=mask23
    pop hl                      ; HL0
    ld c,a
    ld a,l
    and e
    ld l,a
    ld a,h
    and d
    ld h,a
    pop de                      ; DE0
    ld a,e
    and c
    ld e,a
    pop bc                      ; BC = HL0
    ld a,l
    cp c
    jr NZ,ch_pop
    ld a,h
    cp b
    jr NZ,ch_pop
    pop bc                      ; BC = DE0
    ld a,e
    cp c
    jr NZ,ch
    ld a,d
    cp b
    jr NZ,ch
    or a                        ; NC identical
    ret

.ch_pop
    pop bc
.ch
    scf
    ret

.return_zero
    ld a,d
    rla                         ; sign -> C
    ld d,0
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    scf
    ret

.zero_legal
    pop af                          ; C = sign, D = 0
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    or a                            ; NC
    ret
