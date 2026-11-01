;
;  Copyright (c) 2026 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, November 2026
;
;-------------------------------------------------------------------------
; asm_am9511_pow - am9511 floating point power x^y
;-------------------------------------------------------------------------
;
; Integer |y| < 2^24 is exponentiation by squaring on FMUL.
; A negative exponent finishes with one FDIV of 1 by that power.
; Every other y, including |y| >= 2^24, uses PWR.
;
; The running base and product stay in Am9511 byte order.  No IX or IY:
; the ixiy library is this file with the index prefixes swapped.
;
; Frame, low address at SP, built only for |n| >= 2:
;
;   +0  acc LSB .. +3 acc MSB
;   +4  live      +5 pad
;   +6  base LSB .. +9 base MSB
;   +10 n_lo +11 n_mid +12 n_hi +13 sign (1 = negative exponent)
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_pushf
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_pow, asm_am9511_pow_callee


; enter : stack = x, ret
;         dehl  = y
.asm_am9511_pow
    call asm_am9511_pushf
    jr pow_join

.asm_am9511_pow_callee
    call asm_am9511_pushf
    pop bc
    pop af
    pop af
    push bc

.pow_join
    ld a,d
    and 07fh
    or e
    or h
    or l
    jr nz, pow_save

    ld a,__IO_APU_OP_POPF       ; discard x.  y == ±0 → +1, including 0^0
    AM9511_OUT_APU_CONTROL
    ld de,03f80h
    ld hl,0
    ret

.pow_save
    push de                     ; y must survive a failed integer test
    push hl

    ld a,e
    add a,a
    ld a,d
    adc a,a                     ; A = biased exponent, CF = sign
    ld b,0
    jr nc, pow_exp
    inc b
.pow_exp
    ld c,a
    cp 127
    jp c, pow_pwr
    cp 151                      ; |y| >= 2^24, or a non-integral magnitude
    jp nc, pow_pwr

    ld a,e
    and 07fh
    or 80h
    ld e,a                      ; EHL = 24-bit significand
    ld a,150
    sub c                       ; fractional bits
    jr z, pow_int
    ld c,a
.pow_shift
    srl e
    rr h
    rr l
    jp c, pow_pwr               ; a bit fell off: not an integer
    dec c
    jr nz, pow_shift

.pow_int
    pop af                      ; drop saved y
    pop af
    ld a,e
    or h
    jp nz, pow_frame
    ld a,l
    dec a
    jp nz, pow_frame            ; |n| >= 2

    ld a,b
    or a
    jr nz, pow_inv

    ld a,__IO_APU_OP_CHSF       ; x^1.  Two sign flips refresh status
    AM9511_OUT_APU_CONTROL
    ld a,__IO_APU_OP_CHSF
    AM9511_OUT_APU_CONTROL
    jp asm_am9511_popf

.pow_inv
    ld de,03f80h                ; x^(-1) = 1/x
    ld hl,0
    call asm_am9511_pushf_fastcall
    ld a,__IO_APU_OP_XCHF
    AM9511_OUT_APU_CONTROL
    ld a,__IO_APU_OP_FDIV
    AM9511_OUT_APU_CONTROL
    jp asm_am9511_popf

.pow_frame
    ld d,b                      ; sign
    push de                     ; n_hi, sign
    push hl                     ; n_lo, n_mid
    AM9511_IN_APU_DATA          ; base, MSB first
    ld d,a
    AM9511_IN_APU_DATA
    ld e,a
    AM9511_IN_APU_DATA
    ld h,a
    AM9511_IN_APU_DATA
    ld l,a
    push de
    push hl
    ld hl,0
    push hl                     ; live = 0
    push hl
    push hl                     ; acc = 0

.pow_loop
    ld hl,sp+12
    srl (hl)                    ; n >>= 1, CF = old bit 0
    dec hl
    rr (hl)
    dec hl
    rr (hl)
    jr c, pow_bit

.pow_square
    ld hl,sp+6
    call pow_push4
    ld hl,sp+6
    call pow_push4
    ld a,__IO_APU_OP_FMUL
    AM9511_OUT_APU_CONTROL
    call pow_fmul_status
    ld hl,sp+9
    call pow_pop4
    jr pow_loop

.pow_bit
    ld hl,sp+4
    ld a,(hl)
    or a
    jr z, pow_copy
    ld hl,sp+0
    call pow_push4             ; acc, then base.  FMUL is NOS * TOS
    ld hl,sp+6
    call pow_push4
    ld a,__IO_APU_OP_FMUL
    AM9511_OUT_APU_CONTROL
    call pow_fmul_status
    ld hl,sp+3
    call pow_pop4
    jr pow_nzero

.pow_copy
    ld hl,sp+0
    ld de,hl
    ld hl,sp+6
    ld bc,4
    ldir
    ld hl,sp+4
    ld (hl),1

.pow_nzero
    ld hl,sp+10
    ld a,(hl)
    inc hl
    or (hl)
    inc hl
    or (hl)
    jr nz, pow_square           ; the top bit is still ahead

.pow_done
    ld hl,sp+0                  ; last product is the sole APU value
    call pow_push4
    ld hl,sp+13
    ld a,(hl)
    ld hl,14
    add hl,sp
    ld sp,hl
    or a
    jr z, pow_popf
    ld de,03f80h
    ld hl,0
    call asm_am9511_pushf_fastcall
    ld a,__IO_APU_OP_XCHF
    AM9511_OUT_APU_CONTROL
    ld a,__IO_APU_OP_FDIV
    AM9511_OUT_APU_CONTROL

.pow_popf
    jp asm_am9511_popf

.pow_pwr
    pop hl
    pop de
    call asm_am9511_pushf_fastcall
    ld a,__IO_APU_OP_PWR
    AM9511_OUT_APU_CONTROL
    jp asm_am9511_popf


; Return when FMUL has no error code.  On a range error the product is the
; only stack item: a positive exponent is popped as IEEE, and a negative
; exponent swaps overflow with underflow.  NEGRT and DIV0 stay with popf.
.pow_fmul_status
    AM9511_IN_APU_STATUS
    rlca
    jr nc, pow_fmul_ready
    ex (sp),hl
    ex (sp),hl
    jr pow_fmul_status

.pow_fmul_ready
    rrca
    and 01eh
    ret z
    pop de                      ; leave the squaring loop
    ld c,a
    ld hl,sp+13
    ld a,(hl)
    or a
    jp z, pow_fail_popf
    ld a,c
    and 06h
    jp z, pow_fail_popf
    and 02h
    jp nz, pow_fail_zero

    AM9511_IN_APU_DATA          ; underflow ^ -1 → Inf, same sign
    and 080h
    or 07fh
    ld b,a
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    ld hl,14
    add hl,sp
    ld sp,hl
    ld d,b
    ld e,080h
    ld hl,0
    ret

.pow_fail_zero
    AM9511_IN_APU_DATA          ; overflow ^ -1 → 0
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    ld hl,14
    add hl,sp
    ld sp,hl
    ld de,0
    ld hl,0
    ret

.pow_fail_popf
    ld hl,14
    add hl,sp
    ld sp,hl
    jp asm_am9511_popf

.pow_push4
    ld a,(hl)
    inc hl
    AM9511_OUT_APU_DATA
    ld a,(hl)
    inc hl
    AM9511_OUT_APU_DATA
    ld a,(hl)
    inc hl
    AM9511_OUT_APU_DATA
    ld a,(hl)
    inc hl
    AM9511_OUT_APU_DATA
    ret

.pow_pop4
    AM9511_IN_APU_DATA
    ld (hl),a
    dec hl
    AM9511_IN_APU_DATA
    ld (hl),a
    dec hl
    AM9511_IN_APU_DATA
    ld (hl),a
    dec hl
    AM9511_IN_APU_DATA
    ld (hl),a
    dec hl
    ret
