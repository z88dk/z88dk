;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsmul10u

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
    rla                         ; rl d through C
    ld d,a
    jr Z,zero_legal

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

    ex de,hl                    ; hl = d|e_shifted, de = h|l shifted
    ex (sp),hl                  ; hl = orig hl; (sp) = d|e_sh
    add hl,de                   ; sum of mantissa lows
    pop de                      ; de = d|e_sh
    ex (sp),hl                  ; hl = orig de (d|e); (sp) = sum hl
    ld a,l
    adc a,e
    ld e,a
    pop hl                      ; hl = sum of lows

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
