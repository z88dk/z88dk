;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv - z80 restoring IEEE single divide
;-------------------------------------------------------------------------
;
; No index registers.  Main + alternate set only.
;
; Entry (exx shuttles b while a is formed as HLDE):
;   m32_fsdiv        DEHL = b; stack = ret, a [, b]
;   m32_fsdiv_callee DEHL = b; stack = ret, a   (drops a)
;
; 14-byte work frame under ret; b remains above ret for specials/unpack:
;   +1..+3 d   +4..+6 r   +7 ovf   +8 exp   +9 sign
;   +10..+13 a IEEE snapshot   +14 ret   +16 b
;
; Hot path rem/div in hlhl'/dede' (cf. l_fast_divu_32_32x32):
;   trial sbc with C = rem high bit from previous adc hl,hl chain;
;   restore on borrow; quot bit from explicit scf / or a; rem <<= 1
;   leaves C for the next trial (no ovf byte).
;
; Result DEHL = a / b.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsdiv, m32_fsdiv_callee


; ---- non-callee ----
.m32_fsdiv
    pop bc                      ; ret
    push de
    push hl                     ; b on stack
    ld hl,4
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a                      ; HLDE = a
    exx
    pop hl
    pop de                      ; b → DEHL'
    push de
    push hl                     ; b restored under ret
    exx
    push bc                     ; ret; SP = ret, b, a, ...
    jr div_body

; ---- callee ----
.m32_fsdiv_callee
    pop bc                      ; ret
    push de
    push hl                     ; b
    ld hl,4
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a                      ; HLDE = a
    exx
    pop hl
    pop de                      ; b
    pop af
    pop af                      ; drop a
    push de
    push hl                     ; b
    exx
    push bc                     ; ret; SP = ret, b

.div_body
    ; HLDE = a; SP = ret, b — snapshot a then open frame
    ld a,h
    ex af,af                    ; A' = aH
    ld a,l                      ; aL
    ld bc,de                    ; aD:aE

    ld hl,-14
    add hl,sp
    ld sp,hl

    ; ---- store a (one walk +0..+3 from +10) and sign ----
    ld hl,10
    add hl,sp
    ld (hl),c                   ; aE
    inc hl
    ld (hl),b                   ; aD
    inc hl
    ld (hl),a                   ; aL
    inc hl
    ex af,af
    ld (hl),a                   ; aH
    ld e,a                      ; E = aH
    ld hl,19
    add hl,sp                   ; b3
    xor (hl)
    and 080h
    ld hl,9
    add hl,sp
    ld (hl),a                   ; sign

    ; ---- specials: HL → aH; DE → b3 after first checks ----
    ld a,e                      ; aH
    and 07fh
    cp 07fh
    jr NZ,div_a_ok
    ld hl,12
    add hl,sp
    bit 7,(hl)                  ; aL
    jr Z,div_a_ok
    ld a,(hl)
    and 07fh
    dec hl
    or (hl)                     ; aD
    dec hl
    or (hl)                     ; aE
    jp NZ,div_nan
    ld hl,19
    add hl,sp
    ld a,(hl)
    and 07fh
    cp 07fh
    jp NZ,div_inf
    dec hl
    bit 7,(hl)
    jp Z,div_inf
    jp div_nan

.div_a_ok
    ld hl,19
    add hl,sp
    ld a,(hl)                   ; b3
    and 07fh
    cp 07fh
    jr NZ,div_b_ok
    dec hl
    bit 7,(hl)                  ; b2
    jr Z,div_b_ok
    ld a,(hl)
    and 07fh
    dec hl
    or (hl)
    dec hl
    or (hl)
    jp NZ,div_nan
    jp div_zero

.div_b_ok
    ld hl,19
    add hl,sp
    ld a,(hl)
    and 07fh
    dec hl
    or (hl)
    dec hl
    or (hl)
    dec hl
    or (hl)
    jr NZ,div_b_nz
    ld hl,13
    add hl,sp
    ld a,(hl)
    and 07fh
    dec hl
    or (hl)
    dec hl
    or (hl)
    dec hl
    or (hl)
    jp Z,div_nan
    jp div_inf

.div_b_nz
    ld hl,13
    add hl,sp
    ld a,(hl)
    and 07fh
    dec hl
    or (hl)
    dec hl
    or (hl)
    dec hl
    or (hl)
    jp Z,div_zero
    ; ---- unpack a → r +4..+6, exp → +8 ----
    ld hl,13
    add hl,sp
    ld a,(hl)                   ; aH
    add a,a
    ld b,a
    dec hl                      ; aL
    ld a,(hl)
    rlca
    and 1
    or b
    ld c,a                      ; exp a
    or a
    jr NZ,div_a_nrm
    ld a,(hl)
    and 07fh
    ld hl,6
    add hl,sp
    ld (hl),a
    ld c,1
    jr div_a_up

.div_a_nrm
    ld a,(hl)
    or 080h
    ld hl,6
    add hl,sp
    ld (hl),a
.div_a_up
    ld hl,11
    add hl,sp
    ld a,(hl)                   ; aD
    ld hl,5
    add hl,sp
    ld (hl),a                   ; r1
    ld hl,10
    add hl,sp
    ld a,(hl)                   ; aE
    ld hl,4
    add hl,sp
    ld (hl),a                   ; r0
    ld hl,8
    add hl,sp
    ld (hl),c                   ; exp

    ; ---- unpack b → d +1..+3 ----
    ld hl,19
    add hl,sp
    ld a,(hl)
    add a,a
    ld b,a
    dec hl
    ld a,(hl)
    rlca
    and 1
    or b
    ld c,a
    or a
    jr NZ,div_b_nrm
    ld a,(hl)
    and 07fh
    ld hl,3
    add hl,sp
    ld (hl),a
    ld c,1
    jr div_b_up

.div_b_nrm
    ld a,(hl)
    or 080h
    ld hl,3
    add hl,sp
    ld (hl),a
.div_b_up
    ld hl,17
    add hl,sp
    ld a,(hl)
    ld hl,2
    add hl,sp
    ld (hl),a
    ld hl,16
    add hl,sp
    ld a,(hl)
    ld hl,1
    add hl,sp
    ld (hl),a

; exp = exp_a - exp_b + 127
    ld hl,8
    add hl,sp
    ld a,(hl)
    sub c
    ld l,a
    ld h,0
    bit 7,a
    jr Z,div_exp_pos
    ld h,0ffh
.div_exp_pos
    ld de,127
    add hl,de
    bit 7,h
    jr NZ,div_exp_neg
    ld a,h
    or a
    jp NZ,div_inf
    ld a,l
    cp 255
    jp NC,div_inf
    or a
    jr Z,div_exp_denorm
    ld hl,8
    add hl,sp
    ld (hl),a
    jr div_pre_norm

.div_exp_denorm
    ld hl,9
    add hl,sp
    ld a,(hl)
    or 041h
    ld (hl),a
    ld a,1
    ld hl,8
    add hl,sp
    ld (hl),a
    jr div_pre_norm

.div_exp_neg
    ld a,h
    inc a
    jp NZ,div_zero
    ld a,l
    cp 0e9h
    jp C,div_zero
    ld a,1
    sub l
    ld c,a
    ld hl,9
    add hl,sp
    ld a,(hl)
    or 040h
    or c
    ld (hl),a
    ld a,1
    ld hl,8
    add hl,sp
    ld (hl),a

.div_pre_norm
    ; Load 24-bit rem/div into 32-bit hlhl'/dede'
    ; rem r2:r1:r0 at +5..+3; div d2:d1:d0 at +2..+0
    ; (frame still uses +1.. for d0 historically → d0 at +1)
    ld hl,4
    add hl,sp
    ld e,(hl)                   ; r0
    inc hl
    ld d,(hl)                   ; r1
    inc hl
    ld a,(hl)                   ; r2
    ld hl,1
    add hl,sp
    ld c,(hl)                   ; d0
    inc hl
    ld b,(hl)                   ; d1
    inc hl
    ld l,(hl)                   ; d2
    ld h,0                      ; HL = div_hi
    push bc                     ; div_lo
    push hl                     ; div_hi
    push de                     ; rem_lo
    ld l,a
    ld h,0
    push hl                     ; rem_hi
    pop hl                      ; HL  = rem_hi
    exx
    pop hl                      ; HL' = rem_lo
    exx
    pop de                      ; DE  = div_hi
    exx
    pop de                      ; DE' = div_lo
    exx                         ; MAIN: rem_hi,div_hi  ALT: rem_lo,div_lo

    ; if rem < div: rem<<=1, exp--; leave C as rem high bit for first trial
    or a
    exx
    sbc hl,de
    exx
    sbc hl,de
    jr C,div_pre_less
    exx
    add hl,de
    exx
    adc hl,de
    or a                        ; C = 0 for first trial
    jr div_loop_start

.div_pre_less
    exx
    add hl,de
    exx
    adc hl,de
    exx
    add hl,hl
    exx
    adc hl,hl                   ; C = rem high bit after prenorm shift
    push hl
    ld hl,10                    ; exp at +8, +2 for push
    add hl,sp
    dec (hl)
    pop hl
    ; C preserved through push/pop of HL? push hl does not affect C. Good.

    ; ---- 24-bit restoring (l_fast carry-linked style) ----
    ; C = rem bit32 into trial sbc (no ovf byte).  ld r,n preserves C.
    ; MAIN B=count C=qhi; ALT BC'=qlo
    ; 2× unroll: 12 outer steps × 2 bits
.div_loop_start
    ld c,0
    exx
    ld bc,0
    exx
    ld b,12
.div_lp
    ; --- bit ---
    exx
    sbc hl,de
    exx
    sbc hl,de
    jr NC,div_b1a
    exx
    add hl,de
    exx
    adc hl,de
    or a
    jr div_q1

.div_b1a
    scf
.div_q1
    exx
    rl c
    rl b
    exx
    rl c
    exx
    add hl,hl
    exx
    adc hl,hl
    ; --- bit ---
    exx
    sbc hl,de
    exx
    sbc hl,de
    jr NC,div_b1b
    exx
    add hl,de
    exx
    adc hl,de
    or a
    jr div_q2

.div_b1b
    scf
.div_q2
    exx
    rl c
    rl b
    exx
    rl c
    exx
    add hl,hl
    exx
    adc hl,hl
    djnz div_lp

    ; guard / RNE — C = rem high bit after last rem<<1
    exx
    sbc hl,de
    exx
    sbc hl,de
    jr C,div_guard_rest
    ; rem >= div: already subtracted; sticky = rem != 0
    ld a,h
    exx
    or h
    or l
    exx
    or l
    jr NZ,div_rnd_up
    exx
    bit 0,c
    exx
    jr Z,div_q_saved
.div_rnd_up
    exx
    inc c
    jr NZ,div_rnd_ok
    inc b
    jr NZ,div_rnd_ok
    exx
    inc c
    jr NZ,div_q_saved
    ld c,080h
    push hl
    ld hl,10
    add hl,sp
    inc (hl)
    ld a,(hl)
    pop hl
    cp 255
    jp Z,div_inf
    jr div_q_saved

.div_rnd_ok
    exx
    jr div_q_saved

.div_guard_rest
    exx
    add hl,de
    exx
    adc hl,de

.div_q_saved
    ; C = qhi, BC' = qlo → B:D:E for pack
    ld b,c
    exx
    push bc
    exx
    pop de                      ; B=qhi, DE=qlo

    ld hl,9
    add hl,sp
    bit 6,(hl)
    jr NZ,div_denorm_check
    ld hl,8
    add hl,sp
    ld a,(hl)                   ; exp
    or a
    jr Z,div_denorm_s1
.div_normal_pack
    ; A = exp, B = quot hi, D mid, E lo
    ld c,a
    ld a,b
    and 07fh
    bit 0,c
    jr Z,div_pk0
    or 080h
.div_pk0
    ld b,a
    ld a,c
    srl a
    ld c,a
    ld hl,9
    add hl,sp
    ld a,(hl)
    and 080h
    or c
    ld h,a
    ld l,b
    jr div_done

.div_denorm_s1
    srl b
    rr d
    rr e
    ld hl,9
    add hl,sp
    ld a,(hl)
    and 080h
    ld h,a
    ld l,b
    jr div_done

.div_denorm_check
    ld hl,9
    add hl,sp
    ld a,(hl)
    and 03fh
    ld c,a
    ld hl,8
    add hl,sp
    ld a,(hl)
    sub c
    bit 7,a
    jr NZ,div_denorm_neg
    or a
    jr Z,div_denorm_zero
    jr div_normal_pack

.div_denorm_neg
    ld c,a
    ld a,1
    sub c
    jr div_denorm_shift

.div_denorm_zero
    ld a,1
.div_denorm_shift
    ld c,a
.div_denorm_lp
    srl b
    rr d
    rr e
    dec c
    jr NZ,div_denorm_lp
    ld hl,9
    add hl,sp
    ld a,(hl)
    and 080h
    ld h,a
    ld l,b

.div_done
    ; HLDE result.  Free frame; drop b; restore ret.
    ld bc,hl
    ld hl,14
    add hl,sp
    ld sp,hl
    pop hl
    pop af
    pop af
    push hl
    ex de,hl
    ld de,bc
    ret

.div_nan
    ld hl,07fc0h
    ld de,0
    jr div_done

.div_inf
    ld hl,9
    add hl,sp
    ld a,(hl)
    or 07fh
    ld h,a
    ld l,080h
    ld de,0
    jr div_done

.div_zero
    ld hl,9
    add hl,sp
    ld a,(hl)
    and 080h
    ld h,a
    ld l,0
    ld de,0
    jr div_done
