;
;  feilipu, 2020 June / 2026 September (gbz80)
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
EXTERN f16_gbz80_mulu_32_16x16

PUBLIC asm_f16_poly_callee
PUBLIC asm_f16_poly

.asm_f16_poly_callee
    pop bc                      ; uret (BC stays live — not a swap temp)
    pop hl                      ; x
    pop de                      ; d[]
    ; open-code ex (sp),hl — preserve BC/DE (helper is 148c)
    push de                     ; park d[]
    ld de,hl                    ; DE = x
    ld hl,sp+2                  ; &n
    ld a,(hl)
    ld (hl),e
    ld e,a
    inc hl
    ld a,(hl)
    ld (hl),d
    ld h,a
    ld l,e                      ; HL = n; (sp+2) = x
    pop de                      ; DE = d[]
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

    ;; x half
    ld hl,sp+6
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    call asm_f24_f16
    push de
    push hl                     ; [x.hl][x.de][coeff][n][uret][xhalf]

    ; res = d[n]
    ;; coeff
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    call load_f32
    call asm_f24_f32            ; DEHL = res

.poly_loop
    ; DEHL = res — preserve while reading n (u8 at low of word)
    push de
    push hl
    ;; n at +6 +4
    ld hl,sp+10
    ld a,(hl)
    or a
    jp Z,poly_done
    dec a
    ld (hl),a
    pop hl
    pop de                      ; DEHL = res

    call poly_mulx              ; res *= stacked x; x stays on frame

    ; + d[n] (n already decremented; step coeff back first)
    push de
    push hl                     ; X=product
    ;; coeff pointer at sp+8; step back 4 bytes and store
    ld hl,sp+8
    ld a,(hl+)
    ld e,a
    ld a,(hl)
    ld d,a                      ; DE = coeff
    ld hl,-4
    add hl,de                   ; HL = new coeff
    ld de,hl                    ; DE = new
    ld hl,sp+8
    ld a,e
    ld (hl+),a
    ld (hl),d
    ld hl,de                    ; HL = new coeff
    call load_f32
    call asm_f24_f32
    call asm_f24_add_f24
    jp poly_loop

.poly_done
    pop hl                      ; res.hl
    pop de                      ; res.de
    ; [x.hl][x.de][coeff][n][uret][xhalf]
    pop bc                      ; drop x.hl
    pop bc                      ; drop x.de
    pop bc                      ; drop coeff
    pop bc                      ; drop n
    pop bc                      ; uret
    add sp,2                    ; drop x half
    push bc
    jp asm_f16_f24

; Finite f24 mul: DEHL = res, stack [ret][x.hl][x.de]...
; Poly x is a reduced argument; skip Inf/NaN. 16×16 core.
.poly_mulx
    ld b,d                      ; B = res.exp
    ld c,e                      ; C = res.sign
    push hl                     ; res.mant  [rm][ret][x.hl][x.de]
    ld hl,sp+6
    ld a,(hl+)                  ; x.sign
    ld h,(hl)                   ; x.exp
    xor c
    ld c,a                      ; result sign
    ld a,h                      ; x.exp; ±0 classified by IEEE caller
    ld d,b                      ; D = res.exp
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
    ld b,a                      ; result exp
    pop hl                      ; res.mant
    push bc                     ; [exp/sign][ret][x.hl][x.de]
    ld bc,hl                    ; BC = res.mant
    ld hl,sp+4
    ld a,(hl+)
    ld h,(hl)
    ld l,a                      ; HL = x.mant
    ld de,bc                    ; DE = res.mant
    call f16_gbz80_mulu_32_16x16
    pop bc                      ; B=exp C=sign
    bit 7,d
    jr NZ,pm_ge2
    add hl,hl
    rl e
    rl d
    jr pm_norm
.pm_ge2
    inc b
    jr Z,pm_ov2
.pm_norm
    push hl
    ld hl,de
    pop de
    ld a,d
    and 0c0h
    jr Z,pm_rnd
    set 0,l
.pm_rnd
    ld de,bc
    ret

.pm_zero_pop
    pop hl                      ; res.mant
.pm_zero
    ld e,c
    jp asm_f24_zero

.pm_ov
    pop hl                      ; res.mant
.pm_ov2
    ld e,c
    jp asm_f24_inf

; HL=ptr → IEEE float LE into DEHL for asm_f24_f32
; DE = b3:b2, HL = b1:b0
.load_f32
    ld a,(hl+)
    ld c,a
    ld a,(hl+)
    ld b,a                      ; BC = b1:b0
    ld a,(hl+)
    ld e,a
    ld a,(hl)
    ld d,a                      ; DE = b3:b2
    ld hl,bc                    ; HL = b1:b0
    ret
