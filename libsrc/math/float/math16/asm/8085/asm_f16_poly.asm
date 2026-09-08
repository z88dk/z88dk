;
;  feilipu, 2020 June / 2026 August (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_poly — Horner: res=d[n]; while(n) res=res*x+d[--n];
;-------------------------------------------------------------------------
; asm_f16_poly: HL=n, DE=d[], stack=[uret][x_half]
; asm_f16_poly_callee: stack=[uret][x][d][n]
; Prefer ld hl,(de) / ld (de),hl over byte traffic via A.
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f24_f32
EXTERN asm_f16_f24
EXTERN asm_f24_add_f24
EXTERN asm_f24_zero
EXTERN asm_f24_inf
EXTERN f16_8085_mulu_32_16x16

PUBLIC asm_f16_poly_callee
PUBLIC asm_f16_poly

.asm_f16_poly_callee
    pop bc                      ; uret
    pop hl                      ; x
    pop de                      ; d[]
    ex (sp),hl                  ; HL=n, (sp)=x
    push bc                     ; [uret][x]

.asm_f16_poly
    ; HL=n, DE=d[], [uret][x]
    ld c,l                      ; n in C (stack low byte)
    ld b,0
    push bc                     ; [n][uret][x]
    ld l,c
    ld h,0
    add hl,hl
    add hl,hl
    add hl,de                   ; &d[n]
    push hl                     ; [coeff][n][uret][x]

    ld de,sp+6
    ld hl,(de)                  ; x half
    call asm_f24_f16
    push de
    push hl                     ; [x.hl][x.de][coeff][n][uret][xhalf]

    ; res = d[n]
    ld de,sp+4
    ld hl,(de)                  ; coeff
    call load_f32
    call asm_f24_f32            ; DEHL = res

.poly_loop
    ; DEHL = res — preserve while reading n (u8 at low of word)
    push de
    push hl
    ld de,sp+10                 ; n at +6 +4
    ld a,(de)
    or a
    jp Z,poly_done
    dec a
    ld (de),a
    pop hl
    pop de                      ; DEHL = res

    call poly_mulx              ; res *= stacked x; x stays on frame

    ; + d[n] (n already decremented; step coeff back first)
    push de
    push hl                     ; X=product
    ld de,sp+8
    ld hl,(de)                  ; coeff
    ld bc,-4
    add hl,bc
    ld (de),hl                  ; store new coeff (word)
    call load_f32
    call asm_f24_f32
    call asm_f24_add_f24
    jp poly_loop

.poly_done
    pop hl                      ; res.hl
    pop de                      ; res.de
    ; [x.hl][x.de][coeff][n][uret][xhalf]
    pop bc
    pop bc
    pop bc
    pop bc
    pop bc                      ; uret
    pop af                      ; x half
    push bc
    jp asm_f16_f24

; HL=ptr → IEEE float LE into DEHL for asm_f24_f32
; DE = b3:b2, HL = b1:b0
.load_f32
    ex de,hl                    ; DE = ptr
    ld hl,(de)                  ; HL = b1:b0
    push hl
    inc de
    inc de
    ld hl,(de)                  ; HL = b3:b2
    pop de                      ; DE = b1:b0
    ex de,hl                    ; DE = b3:b2, HL = b1:b0
    ret

; Finite f24 mul: DEHL = res, stack [ret][x.hl][x.de]...
.poly_mulx
    ld b,d                      ; B = res.exp
    ld c,e                      ; C = res.sign
    push hl                     ; [rm][ret][x.hl][x.de]
    ld de,sp+6
    ld hl,(de)                  ; L=x.sign H=x.exp
    ld a,l
    xor c
    ld c,a                      ; result sign
    ld a,h                      ; x.exp; ±0 classified by IEEE caller
    ld d,b
    sub 07fh
    jr C,pm_uf
    add a,d
    jr C,pm_ov
    jr pm_ok
.pm_uf
    add a,d
    jp NC,pm_zero_pop
.pm_ok
    or a
    jp Z,pm_zero_pop
    ld b,a
    pop hl                      ; res.mant
    push bc                     ; [exp/sign][ret][x.hl][x.de]
    ld de,sp+4
    push hl
    ld hl,(de)                  ; x.mant
    pop de                      ; DE = res.mant
    call f16_8085_mulu_32_16x16
    pop bc
    ld a,d
    rla
    jr C,pm_ge2
    add hl,hl
    rl de
    jr pm_norm
.pm_ge2
    inc b
    jr Z,pm_ov2
.pm_norm
    ex de,hl
    ld a,d
    and 0c0h
    jr Z,pm_rnd
    ld a,l
    or 001h
    ld l,a
.pm_rnd
    ld de,bc
    ret

.pm_zero_pop
    pop hl
.pm_zero
    ld e,c
    jp asm_f24_zero

.pm_ov
    pop hl
.pm_ov2
    ld e,c
    jp asm_f24_inf
