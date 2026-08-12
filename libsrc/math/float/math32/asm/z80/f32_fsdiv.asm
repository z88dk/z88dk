;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv — z80 restoring IEEE single divide
;-------------------------------------------------------------------------
;
; No index registers.  Main + alternate set only.
;
; Entry:
;   m32_fsdiv        DEHL = b; stack = ret, a [, b]  (a left for caller)
;   m32_fsdiv_callee DEHL = b; stack = ret, a         (drops a)
;
; 12-byte work frame under ret; b remains above ret for specials/unpack:
;   +0..+2 div   +3..+5 rem seed   +6 expR   +7 sign
;   +8..+11 a IEEE snapshot   +12 ret   +14 b
;
; Hot path (register-held rem + div, cf. l_fast_divu_32_32x32):
;   MAIN: rem_hi / div_hi in HL/DE; ALT: rem_lo / div_lo in HL'/DE'
;   trial sbc with C = rem high bit from previous adc hl,hl chain;
;   restore on borrow; quot bit via scf / or a; rem <<= 1 leaves C.
;
; Label map (aligned with asm/8085/f32_fsdiv.asm):
;   div_enter/body, div_prenorm, div_bit_loop, div_bit_fail/ok,
;   div_quot_shift, div_guard_*, div_round_up, div_pack*, specials.
;
; Reuses: m32_fsconst_* for NaN; m32_fszero / m32_fsmax for signed 0/inf
; after frame drop (sign in D).  Classification remains open-coded (avoids
; extra stack walks vs m32_fpclassify at this frame depth).
;
; Denormals: not supported (math32 policy).  exp==0 is ±0 on input;
; result underflow flushes to signed zero (no gradual underflow).
;
; Result DEHL = a / b.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_pnan
EXTERN m32_fszero, m32_fsmax

PUBLIC m32_fsdiv, m32_fsdiv_callee


; ---- non-callee: leave a under ret,b; thin trampoline into body ----
.m32_fsdiv
    pop bc                      ; ret
    push de
    push hl                     ; b
    push bc                     ; ret → SP = ret, b, a
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
    jr div_enter

; ---- callee: drop a ----
.m32_fsdiv_callee
    pop bc                      ; ret
    push de
    push hl                     ; b → SP = b, a
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
    push bc                     ; ret → SP = ret, b

.div_enter
    ; HLDE = a; SP = ret, b — snapshot a then open 12-byte frame
    ld a,h
    ex af,af                    ; A' = aH
    ld a,l                      ; aL
    ld bc,de                    ; aD:aE

    ld hl,-12
    add hl,sp
    ld sp,hl

    ; ---- store a (+8..+11) and sign (+7) ----
    ld hl,8
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
    ld hl,17
    add hl,sp                   ; b3
    xor (hl)
    and 080h
    ld hl,7
    add hl,sp
    ld (hl),a                   ; sign

    ; ---- specials ----
    ld a,e                      ; aH
    and 07fh
    cp 07fh
    jr NZ,div_a_ok
    ld hl,10
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
    ld hl,17
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
    ld hl,17
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
    ; math32: exp==0 is ±0 (denormals not supported → flush to zero)
    ld hl,17
    add hl,sp
    ld a,(hl)                   ; b3
    add a,a
    ld b,a
    dec hl                      ; b2
    ld a,(hl)
    rlca
    and 1
    or b                        ; exp b
    jr NZ,div_b_nz
    ld hl,11
    add hl,sp
    ld a,(hl)                   ; aH
    add a,a
    ld b,a
    dec hl
    ld a,(hl)
    rlca
    and 1
    or b                        ; exp a
    jp Z,div_nan                ; 0/0
    jp div_inf                  ; x/0

.div_b_nz
    ld hl,11
    add hl,sp
    ld a,(hl)                   ; aH
    add a,a
    ld b,a
    dec hl                      ; aL
    ld a,(hl)
    rlca
    and 1
    or b                        ; exp a
    jp Z,div_zero               ; 0/y (incl. denormal a)
    ld c,a                      ; C = exp a (1..254)
    ; ---- unpack a → r +3..+5, exp → +6 (normals only) ----
    ld a,(hl)
    or 080h                     ; implicit 1
    ld hl,5
    add hl,sp
    ld (hl),a                   ; r2
    ld hl,9
    add hl,sp
    ld a,(hl)                   ; aD
    ld hl,4
    add hl,sp
    ld (hl),a                   ; r1
    ld hl,8
    add hl,sp
    ld a,(hl)                   ; aE
    ld hl,3
    add hl,sp
    ld (hl),a                   ; r0
    ld hl,6
    add hl,sp
    ld (hl),c                   ; exp a

    ; ---- unpack b → d +0..+2 ----
    ld hl,17
    add hl,sp
    ld a,(hl)
    add a,a
    ld b,a
    dec hl
    ld a,(hl)
    rlca
    and 1
    or b
    ld c,a                      ; exp b (nonzero)
    ld a,(hl)
    or 080h
    ld hl,2
    add hl,sp
    ld (hl),a                   ; d2
    ld hl,15
    add hl,sp
    ld a,(hl)
    ld hl,1
    add hl,sp
    ld (hl),a                   ; d1
    ld hl,14
    add hl,sp
    ld a,(hl)
    ld hl,0
    add hl,sp
    ld (hl),a                   ; d0

; exp = exp_a - exp_b + 127  (FTZ: result exp<=0 → ±0, >=255 → ±inf)
    ld hl,6
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
    jp NZ,div_zero              ; underflow
    ld a,h
    or a
    jp NZ,div_inf
    ld a,l
    cp 255
    jp NC,div_inf
    or a
    jp Z,div_zero               ; exp 0 → flush zero (no subnormals)
    ld hl,6
    add hl,sp
    ld (hl),a

.div_prenorm
    ; Load 24-bit rem/div into 32-bit hlhl'/dede'
    ; rem r2:r1:r0 at +5..+3; div d2:d1:d0 at +2..+0
    ld hl,3
    add hl,sp
    ld e,(hl)                   ; r0
    inc hl
    ld d,(hl)                   ; r1
    inc hl
    ld a,(hl)                   ; r2
    ld hl,0
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
    jr C,div_pre_lt
    exx
    add hl,de
    exx
    adc hl,de
    or a                        ; C = 0 for first trial
    jr div_bit_init

.div_pre_lt
    exx
    add hl,de
    exx
    adc hl,de
    exx
    add hl,hl
    exx
    adc hl,hl                   ; C = rem high bit after prenorm shift
    push hl
    ld hl,8                     ; exp at +6, +2 for push
    add hl,sp
    dec (hl)
    pop hl

    ; ---- 24-bit restoring (l_fast carry-linked style) ----
    ; C = rem bit32 into trial sbc.  MAIN B=count C=qhi; ALT BC'=qlo
    ; 1×: 24 steps × 1 bit
.div_bit_init
    ld c,0
    exx
    ld bc,0
    exx
    ld b,24
.div_bit_loop
    ; --- bit ---
    exx
    sbc hl,de
    exx
    sbc hl,de
    jr NC,div_bit_ok
    exx
    add hl,de
    exx
    adc hl,de
    or a
    jr div_quot_shift

.div_bit_ok
    scf
.div_quot_shift
    exx
    rl c
    rl b
    exx
    rl c
    exx
    add hl,hl
    exx
    adc hl,hl
    djnz div_bit_loop

    ; guard / RNE — C = rem high bit after last rem<<1
    exx
    sbc hl,de
    exx
    sbc hl,de
    jr C,div_guard_restore
    ; rem >= div: already subtracted; sticky = rem != 0
    ld a,h
    exx
    or h
    or l
    exx
    or l
    jr NZ,div_round_up
    exx
    bit 0,c
    exx
    jr Z,div_guard_done
.div_round_up
    exx
    inc c
    jr NZ,div_round_ok
    inc b
    jr NZ,div_round_ok
    exx
    inc c
    jr NZ,div_guard_done
    ld c,080h
    push hl
    ld hl,8                     ; exp at +6, +2 for push
    add hl,sp
    inc (hl)
    ld a,(hl)
    pop hl
    cp 255
    jp Z,div_inf
    jr div_guard_done

.div_round_ok
    exx
    jr div_guard_done

.div_guard_restore
    exx
    add hl,de
    exx
    adc hl,de

.div_guard_done
    ; C = qhi, BC' = qlo → B:D:E for pack
    ld b,c
    exx
    push bc
    exx
    pop de                      ; B=qhi, DE=qlo

    ld hl,6
    add hl,sp
    ld a,(hl)                   ; exp (prenorm may have decremented)
    or a
    jp Z,div_zero
    ; A = exp, B = quot hi, D mid, E lo — normals only (FTZ)
    ld c,a
    ld a,b
    and 07fh
    bit 0,c
    jr Z,div_pack_exp
    or 080h
.div_pack_exp
    ld b,a
    ld a,c
    srl a
    ld c,a
    ld hl,7
    add hl,sp
    ld a,(hl)
    and 080h
    or c
    ld h,a
    ld l,b

.div_done
    ; Pack form H|L|D|E → IEEE DEHL, then shared unwind.
    push de
    ld d,h
    ld e,l
    pop hl                      ; DEHL = IEEE result
    call div_unwind
    ret

; Cold exits — reuse m32_fszero / m32_fsmax (sign in D) after unwind.
.div_nan
    call div_unwind
    jp m32_fsconst_pnan

.div_inf
    ld hl,7
    add hl,sp
    ld a,(hl)                   ; sign
    and 080h
    ld d,a                      ; D = sign for m32_fsmax
    call div_unwind             ; preserves main DEHL (D kept)
    call m32_fsmax
    or a                        ; clear error CF from m32_fseexit
    ret

.div_zero
    ld hl,7
    add hl,sp
    ld a,(hl)                   ; sign
    and 080h
    ld d,a
    call div_unwind
    jp m32_fszero

; Free 12-byte work + drop b; leave C ret on stack.
; CALL-safe: pops uret, restores it after.  Preserves main DEHL via exx.
.div_unwind
    exx
    pop bc                      ; uret
    ld hl,12
    add hl,sp
    ld sp,hl
    pop hl                      ; C ret
    pop de
    pop de                      ; drop b
    push hl
    push bc                     ; uret
    exx
    ret
