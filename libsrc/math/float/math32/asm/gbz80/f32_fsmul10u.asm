;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; gbz80 m32_fsmul10u

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsmul10u_fastcall
PUBLIC _m32_mul10uf

._m32_mul10uf
.m32_fsmul10u_fastcall
    ld a,e
    add a,a                     ; sla e
    ld e,a
    ld a,d
    rla                         ; exp in D, sign in C
    ld d,a
    push af                     ; keep sign; rla does not set Z
    or a
    jp Z,zero_legal
    pop af

    ld a,d
    inc a
    jr Z,exp_max

    scf
    ld a,e
    rra
    ld e,a                      ; rr e (hidden bit)

    push de
    push hl

    ; ehl >>= 2
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a

    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a

    ; HL = h|l_sh, DE = d|e (D untouched by >>=2). Swap to match 8080 ex de,hl.
    push hl
    ld h,d
    ld l,e                          ; HL = d|e_sh
    pop de                          ; DE = h|l_sh
    ; HL=d|e_sh, DE=h|l_sh, stack: orig_hl, orig_de — no ex (sp),hl
    ld b,h
    ld c,l                          ; BC = d|e_sh
    pop hl                          ; HL = orig_hl
    add hl,de                       ; HL = sum of mantissa lows
    pop de                          ; DE = orig_de
    ld a,e
    adc a,c
    ld e,a                          ; E = mid sum; D := high(d|e_sh)
    ld d,b
    ; HL = sum of lows

    ld a,3
    jr NC,no_carry

    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,4                      ; exp +1 extra

.no_carry
    add a,d
    jr C,infinity

    ld d,a
    ld a,e
    add a,a                     ; sla e
    ld e,a
    ld a,d
    or a
    rra                         ; srl d
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

.zero_legal
    pop af                          ; C = sign
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    ret

.exp_max
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,d
    and 07fh
    ld d,a
    ret

.infinity
    ld de,$7f80
    ld hl,0
    scf
    ret
