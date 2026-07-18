;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsldexp / m32_dmulpow2 — x * 2^n
; Core ABI matches am9511 / Z80 math32.
;
; Core m32_fsldexp_callee:
;   enter : stack = int16_t pw2, float x, ret
;         : SP = ret, x.HL, x.DE, pw2
;
; _m32_ldexpf (sccz80 higher C / public bridge):
;   enter : SP = ret, pw2, x.HL, x.DE  — reverse then core
;
; Uses ld de,sp+d and ld hl,(de). Never parks ret in AF.
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmin

PUBLIC m32_dmulpow2
PUBLIC m32_fsldexp_callee
PUBLIC _m32_ldexpf


; HL = signed power; DEHL = float x
.m32_dmulpow2
    ld bc,hl
    jp pow2


; sccz80 left-to-right entry → core order (same as cam32_sccz80_ldexp_callee)
._m32_ldexpf
    pop hl                          ; ret
    pop bc                          ; pw2
    pop de                          ; x.HL
    ex (sp),hl                      ; HL = x.DE; (sp) = ret
    push bc                         ; pw2
    push hl                         ; x.DE
    push de                         ; x.HL : SP = x.HL, x.DE, pw2, ret
    call m32_fsldexp_callee
    ret


; float ldexpf (float x, int16_t pw2) — core (SDCC / am9511 order)
; enter : SP = ret, x.HL, x.DE, pw2
; exit  : DEHL = x * 2^pw2
.m32_fsldexp_callee
    ; SP+0 ret, SP+2 x.HL, SP+4 x.DE, SP+6 pw2
    ld de,sp+4
    ld hl,(de)                      ; HL = x.DE

    add hl,hl                       ; exp → H, mant bits → L, sign → C
    inc h
    dec h
    jp Z,ldexp_zero

    ld a,h
    inc a
    jp Z,ldexp_inf_nan              ; exp was 0xff: return x

    ld de,sp+6
    ld a,(de)                       ; (int8_t)pw2
    ld b,a                          ; save for wrap sign test
    add h                           ; new_exp = exp + pw2
    jp C,ldexp_wrap

    or a
    jp Z,ldexp_uflow
    ld c,a
    inc a
    jp Z,ldexp_oflow
    ld h,c                          ; H = new exp

.ldexp_pack
    dec de                          ; de was sp+6 → sp+5 = original D
    ld a,(de)
    rla                             ; sign → C
    ld a,h
    rra
    ld d,a
    ld a,l
    rra
    ld e,a

    pop bc                          ; ret
    pop hl                          ; x.HL mant LSW
    inc sp
    inc sp                          ; drop x.DE
    inc sp
    inc sp                          ; drop pw2
    push bc                         ; ret
    or a
    ret

.ldexp_wrap
    ld a,b
    rla                             ; pw2 sign → C
    jp C,ldexp_uflow

.ldexp_oflow
    ld de,sp+5                      ; original D
    ld a,(de)
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    pop bc                          ; ret
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp                          ; drop x + pw2
    push bc
    scf
    ret

.ldexp_uflow
    ld de,sp+5
    ld a,(de)
    add a,a                         ; sign → C
    ld d,0
    ld e,0
    ld hl,0
    rra
    ld d,a                          ; signed zero
    pop bc                          ; ret
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    push bc
    jp m32_fsmin

.ldexp_zero
    pop bc                          ; ret
    pop hl                          ; x.HL
    pop de                          ; x.DE (sign in D)
    inc sp
    inc sp                          ; drop pw2
    push bc                         ; ret
    ld a,d
    and 080h
    ld d,a
    ld e,0
    ld hl,0
    ret

.ldexp_inf_nan
    pop bc                          ; ret
    pop hl                          ; x.HL
    pop de                          ; x.DE
    inc sp
    inc sp                          ; drop pw2
    push bc                         ; ret
    or a
    ret


; ---- register-arg path for m32_dmulpow2 ----
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
    jp Z,ldexp_pack_reg

    ld a,d
    add a,c
    jp C,ldexp_wrap_reg

    or a
    jp Z,ldexp_uflow_reg
    ld d,a
    inc a
    jp Z,ldexp_oflow_reg

.ldexp_pack_reg
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

.ldexp_wrap_reg
    ld a,c
    rla
    jp C,ldexp_uflow_reg

.ldexp_oflow_reg
    ld a,e
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    ret

.ldexp_uflow_reg
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
    ; sign in C (from rla of D)
    ld e,0
    ld hl,0
    ld a,0
    rra
    ld d,a
    ret
