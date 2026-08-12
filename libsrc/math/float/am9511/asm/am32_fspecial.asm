;
;  feilipu / specials, 2026
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; IEEE-side specials for am9511 float ops
;-------------------------------------------------------------------------
;
; Am9511 APU: 24-bit mantissa, unbiased 7-bit exp (−64…+63), no Inf/NaN.
; pushf maps IEEE exp ≥ 190 (including 255) to APU max — Inf/NaN must be
; handled here before the chip.  On-chip errors (see popf) follow the status
; register in techdocs/amd/am9511a (Am9511 Arithmetic Processor.pdf).
;   OVRFL → ±Inf, UNDFL/ZERO → 0, DIV0 → ±Inf, NEGRT → NaN.
;
; Binary: DEHL = RHS y; stack = ret_spec, ret_user, x as L,H,E,D.
; Exit: CF=1 DEHL=result handled; CF=0 DEHL=y use APU.  x not consumed.
;
; Sqrt: DEHL = x; stack = ret_spec, ret_user.
;
; 8080-compatible (no exx / IX).
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_spec_div
PUBLIC asm_am9511_spec_mul
PUBLIC asm_am9511_spec_add
PUBLIC asm_am9511_spec_sqrt


.ieee_exp
    ld a,e
    add a,a
    ld a,d
    adc a,a
    ret

; HL = offset from SP after CALL into this helper.
; Preserve BC: callers stash operand sign in C across this load.
.load_xo
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = x low
    inc hl
    push de
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = x high
    pop hl                      ; HL = x low
    ret

.load_x10
    ld hl,10
    jr load_xo

.ret_pnan
    ld de,07fffh
    ld h,e
    ld l,e
    scf
    ret

.ret_szero
    ld de,0
    ld h,d
    ld l,e
    scf
    ret

; B.7 = result sign
.ret_sinf_b
    ld hl,0
    ld e,080h
    ld a,b
    and 080h
    or 07fh
    ld d,a
    scf
    ret

.mant_nz
    ld a,e
    and 07fh
    or h
    or l
    ret

; After push de,push hl and load_x10: DEHL=x, y on stack.
; Returns: B = sign_x xor sign_y, A = exp_x, y restored to DEHL on stack still.
; Destroys.  Use: call load_x_signs → A=exp_x, B=sx^sy, DEHL=x; then pop y.
; Simpler pattern used below: keep signs in B/C without push bc.


;=========================================================================
; DIV
;=========================================================================
.asm_am9511_spec_div
    call ieee_exp
    or a
    jp Z,d_y0
    inc a
    jp Z,d_y255

    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,d_apu
    inc a
    jr NZ,d_apu
    call mant_nz
    jr NZ,d_xnan
    ld a,d
    and 080h
    ld b,a                      ; sx
    pop hl
    pop de
    ld a,d
    and 080h
    xor b
    ld b,a
    jp ret_sinf_b

.d_xnan
    pop hl
    pop de
    jp ret_pnan

.d_apu
    pop hl
    pop de
    or a
    ret

.d_y0
    ld a,d
    and 080h
    ld c,a                      ; sy in C
    push de
    push hl
    call load_x10
    ld a,d
    and 080h
    xor c
    ld b,a                      ; result sign
    call ieee_exp
    pop hl
    pop de
    or a
    jp Z,ret_pnan
    jp ret_sinf_b

.d_y255
    call mant_nz
    jp NZ,ret_pnan
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,d_zi
    inc a
    jr NZ,d_fi
    call mant_nz
    pop hl
    pop de
    jp ret_pnan                 ; Inf/Inf or NaN/Inf

.d_zi
    pop hl
    pop de
    jp ret_szero

.d_fi
    pop hl
    pop de
    jp ret_szero


;=========================================================================
; MUL
;=========================================================================
.asm_am9511_spec_mul
    call ieee_exp
    or a
    jp Z,m_y0
    inc a
    jp Z,m_y255

    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,m_apu
    inc a
    jr NZ,m_apu
    call mant_nz
    jr NZ,m_xnan
    ld a,d
    and 080h
    ld b,a
    pop hl
    pop de
    ld a,d
    and 080h
    xor b
    ld b,a
    jp ret_sinf_b

.m_xnan
    pop hl
    pop de
    jp ret_pnan

.m_apu
    pop hl
    pop de
    or a
    ret

.m_y0
    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,m_00
    inc a
    jr NZ,m_0f
    pop hl
    pop de
    jp ret_pnan

.m_00
    pop hl
    pop de
    jp ret_szero

.m_0f
    pop hl
    pop de
    jp ret_szero

.m_y255
    call mant_nz
    jp NZ,ret_pnan
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    ld a,d
    and 080h
    xor c
    ld b,a                      ; result sign
    call ieee_exp
    or a
    jr Z,m_i0
    inc a
    jr Z,m_ii
    pop hl
    pop de
    jp ret_sinf_b               ; Inf * finite

.m_i0
    pop hl
    pop de
    jp ret_pnan

.m_ii
    call mant_nz
    pop hl
    pop de
    jp NZ,ret_pnan
    jp ret_sinf_b               ; Inf * Inf (B has sx^sy)


;=========================================================================
; ADD
;=========================================================================
.asm_am9511_spec_add
    call ieee_exp
    or a
    jp Z,a_y0
    inc a
    jp Z,a_y255

    push de
    push hl
    call load_x10
    call ieee_exp
    or a
    jr Z,a_apu
    inc a
    jr NZ,a_apu
    call mant_nz
    jr NZ,a_xnan
    pop bc
    pop bc
    scf                         ; DEHL = x Inf/NaN handled Inf
    ret

.a_xnan
    pop hl
    pop de
    jp ret_pnan

.a_apu
    pop hl
    pop de
    or a
    ret

.a_y0
    push de
    push hl
    call load_x10
    pop bc
    pop bc
    scf
    ret

.a_y255
    call mant_nz
    jp NZ,ret_pnan
    ld a,d
    and 080h
    ld c,a                      ; sy
    push de
    push hl
    call load_x10
    ld a,d
    and 080h
    ld b,a                      ; sx
    call ieee_exp
    or a
    jr Z,a_i0
    inc a
    jr Z,a_ii
    ; finite + Inf → y Inf
    pop hl
    pop de
    ld b,c
    jp ret_sinf_b

.a_i0
    pop hl
    pop de
    ld b,c
    jp ret_sinf_b

.a_ii
    call mant_nz
    jr NZ,a_iin
    ld a,b
    xor c
    and 080h
    jr NZ,a_iin
    pop hl
    pop de
    ld b,c
    jp ret_sinf_b               ; Inf + Inf same sign

.a_iin
    pop hl
    pop de
    jp ret_pnan


;=========================================================================
; SQRT
;=========================================================================
.asm_am9511_spec_sqrt
    call ieee_exp
    or a
    jp Z,ret_szero
    inc a
    jr NZ,sq_fin
    call mant_nz
    jp NZ,ret_pnan
    ld a,d
    rla
    jp C,ret_pnan
    ld b,0
    jp ret_sinf_b

.sq_fin
    ld a,d
    rla
    jp C,ret_pnan
    or a
    ret
