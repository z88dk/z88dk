;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv — 8085 restoring IEEE single divide
;-------------------------------------------------------------------------
;
; Stack-only (no exx / IX / djnz).
;
; Hot path:
;   DEHL     = rem (L=lo H=mid E=hi D=x)   — register-held remainder
;   B        = bit count
;   work+0..2 = div (lo,mid,hi)            — divisor on frame
;     (Holding div.hi in C was measured slower: each trial needs C as a
;      temporary for stack loads, forcing push/pop bc.)
;
; rem <<= 1 : add hl,hl / rl de
; trial     : rem_sub / rem_add helpers
;
; Library reuse:
;   m32_fpclassify     — classify (0 num, 1 zero, 2 nan, 3 inf)
;   m32_fszero       — signed zero (sign in D)
;   m32_fsmax        — signed inf  (sign in D)
;   m32_fsconst_pnan — NaN
;
; Specials: classify then unpack.  Finite path pays two load4+classify
; before unpack (clearer than open-coding; z80 fsdiv open-codes instead).
; Algebra: a/0→±Inf (0/0→NaN); finite/Inf→±0; Inf/Inf→NaN; NaN/*→NaN.
;
; Entry:
;   m32_fsdiv        DEHL = b; stack = ret, a [, b]
;   m32_fsdiv_callee DEHL = b; stack = ret, a   (drops a)
;
; Frame after open (SP = work base):
;
;   +0  div.lo      3-byte divisor mantissa
;   +1  div.mid
;   +2  div.hi
;   +3  expR
;   +4  quot.lo     3-byte quotient
;   +5  quot.mid
;   +6  quot.hi
;   +7  (pad)
;   +8  sign        word: L = sign in 0x80
;   +10 a           IEEE snapshot (4)
;   +14 b           IEEE snapshot (4)
;   +18 flag        word: L = 1 if callee
;   +20 ret
;
; Labels aligned with asm/z80/f32_fsdiv.asm.
;
; Denormals: not supported (math32 policy).  exp==0 is ±0 on input;
; result underflow flushes to signed zero (no gradual underflow).
;
; Result DEHL = a / b.

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fpclassify
EXTERN m32_fszero, m32_fsmax
EXTERN m32_fsconst_pnan

PUBLIC m32_fsdiv, m32_fsdiv_callee


;=========================================================================
; Entry
;=========================================================================

.m32_fsdiv
    xor a
    jp div_enter

.m32_fsdiv_callee
    ld a,1

.div_enter
    ld b,0
    ld c,a
    push bc                     ; flag

    push de
    push hl                     ; b → SP = b (4), flag (2), ret (2), a
    ld de,sp+8                  ; a, not 4/6: b+flag+ret sit under SP
    call load4                  ; DEHL = a
    push de
    push hl                     ; a

    ld de,sp+3
    ld a,(de)
    ld de,sp+7
    ld l,a
    ld a,(de)
    xor l
    and 080h
    ld l,a
    ld h,0
    push hl                     ; sign

    ld hl,-8
    add hl,sp
    ld sp,hl
    ; work@0  sign@8  a@10  b@14  flag@18  ret@20

;=========================================================================
; Specials gate (m32_fpclassify: 0 num, 1 zero, 2 nan, 3 inf)
;=========================================================================
;   a/0 → ±Inf (0/0 → NaN)   finite/Inf → ±0   Inf/Inf → NaN
;   Inf/finite → ±Inf         NaN/* → NaN        */NaN → NaN

    ld de,sp+10
    call load4
    call m32_fpclassify
    cp 2
    jp Z,div_nan
    cp 3
    jp Z,div_a_inf
    dec a
    jp Z,div_a_zero

    ld de,sp+14
    call load4
    call m32_fpclassify
    cp 2
    jp Z,div_nan
    cp 3
    jp Z,div_b_inf
    dec a
    jp Z,div_b_zero

;=========================================================================
; Unpack a → rem (pushed), expR = exp_a
;=========================================================================

    ld de,sp+10
    call load4
    call ieee_unpack            ; B=exp_a A=mhi HL=mlo

    ld de,sp+3
    push af
    ld a,b
    ld (de),a                   ; expR
    pop af

    ld e,a
    ld d,0
    push de
    push hl                     ; rem high, rem low

;=========================================================================
; Unpack b → div frame; expR = exp_a - exp_b + 127
;=========================================================================

    ld de,sp+18
    call load4
    call ieee_unpack            ; B=exp_b A=mhi HL=mlo

    ld de,sp+4
    ld (de),hl                  ; div.lo:mid
    inc de
    inc de
    ld (de),a                   ; div.hi

    ld de,sp+7
    ld a,(de)
    sub b
    ld e,a
    ld d,0
    jp NC,div_exp_sx
    ld d,0ffh
.div_exp_sx
    ld hl,127
    add hl,de
    ld a,h
    or a
    jp NZ,div_exp_bad_p
    ld a,l
    cp 255
    jp NC,div_overflow_p
    or a
    jp Z,div_underflow_p
    ld de,sp+7
    ld (de),a

    pop hl
    pop de                      ; rem

    push de
    push hl
    ld de,sp+8
    ld hl,0
    ld (de),hl
    inc de
    inc de
    xor a
    ld (de),a                   ; quot = 0
    pop hl
    pop de

;=========================================================================
; Prenorm
;=========================================================================

    call rem_sub
    jr C,div_pre_lt
    call rem_add
    jr div_prenorm_done

.div_pre_lt
    call rem_add
    add hl,hl
    rl de
    push de
    ld de,sp+3+2
    ld a,(de)
    dec a
    ld (de),a
    pop de
.div_prenorm_done

;=========================================================================
; Hot path: 24 bits — rem in DEHL, B=count, div on frame
;=========================================================================

    ld b,24

.div_bit_loop
    call rem_sub                    ; in DEHL=rem; CF if rem < div
    jr C,div_bit_fail
    scf                             ; quot bit = 1 (shifted in at quot_shift)
    jp div_quot_shift

.div_bit_fail
    call rem_add                    ; restore rem; CF from trial is junk
    or a                            ; quot bit = 0

.div_quot_shift
    push de
    push hl
    ld de,sp+4+4                ; &quot
    ld a,(de)
    rla
    ld (de+),a
    ld a,(de)
    rla
    ld (de+),a
    ld a,(de)
    rla
    ld (de),a
    pop hl
    pop de

    add hl,hl
    rl de

    dec b
    jp NZ,div_bit_loop

;=========================================================================
; Guard + RNE
;=========================================================================

    call rem_sub
    jr C,div_guard_restore

    ld a,l
    or h
    or e
    or d
    jr NZ,div_round_up
    ld de,sp+4
    ld a,(de)
    and 1
    jr Z,div_guard_done
.div_round_up
    ld de,sp+4
    ld a,(de)
    inc a
    ld (de+),a                  ; NZ from inc a (ld/inc de keep flags)
    jr NZ,div_guard_done
    ld a,(de)
    inc a
    ld (de+),a                  ; NZ from inc a
    jr NZ,div_guard_done
    ld a,(de)
    inc a
    ld (de),a                   ; NZ from inc a
    jr NZ,div_guard_done
    ld a,080h
    ld (de),a
    ld de,sp+3
    ld a,(de)
    inc a
    ld (de),a
    jr div_guard_done

.div_guard_restore
    call rem_add
.div_guard_done

;=========================================================================
; Pack
;=========================================================================

    ld de,sp+6
    ld a,(de)
    ld b,a
    ld de,sp+4
    ld hl,(de)

    ld a,b
    or a
    rla
    jr C,div_pack
    add hl,hl
    ld a,b
    rla
    ld b,a
    ld de,sp+3
    ld a,(de)
    dec a
    ld (de),a
.div_pack
    ld de,sp+3
    ld a,(de)
    or a
    jp Z,div_underflow
    cp 255
    jp NC,div_overflow
    ld c,a
    ld a,b
    and 07fh
    ld b,a
    ld a,c
    and 1
    jr Z,div_pack_exp
    ld a,b
    or 080h
    ld b,a
.div_pack_exp
    ld a,c
    and 0feh
    rra
    ld c,a
    ld de,sp+8
    ld a,(de)
    and 080h
    or c
    ld d,a
    ld e,b

;=========================================================================
; Epilogue
;=========================================================================
;
; Drop work+sign+a+b (18).  DEHL=result, BC free, flag still on frame.
; Park lo in BC; DE (hi) stays.  SP via HL; restore lo after flag pop.
; Callee drops original a with two pops (4 B — pops beat another adjust).
;

    ld bc,hl                    ; park lo; DE (hi) stays
    ld hl,18                    ; work(8)+sign(2)+a(4)+b(4)
    add hl,sp
    ld sp,hl
    pop hl                      ; flag
    ld a,l
    ld hl,bc                    ; restore lo; DE still hi
    or a
    jr Z,div_done
    pop bc                      ; cret
    pop af
    pop af                      ; drop original a
    push bc
.div_done
    ret

;=========================================================================
; rem_sub / rem_add — CALL SP=work; B=count; DEHL=rem; div@work+0
; Preserves B (bit count).  Pointer in HL so lo/mid can sub (hl).
; C holds div.hi for the last sbc/adc (cannot pop rem high into BC).
;=========================================================================

.rem_sub
    push de                     ; rem high
    ld de,sp+4                  ; &div
    ex de,hl                    ; HL = &div, DE = rem.lo:mid
    ld a,e
    sub (hl+)                   ; rem.lo - div.lo
    ld e,a
    ld a,d
    sbc a,(hl+)                 ; rem.mid - div.mid
    ld d,a
    ld a,(hl)
    ld c,a                      ; C = div.hi
    pop hl                      ; rem high
    ld a,l
    sbc a,c
    ld l,a
    ld a,h
    sbc a,0
    ld h,a
    ex de,hl                    ; DE = high, HL = lo:mid
    ret

.rem_add
    push de                     ; rem high
    ld de,sp+4                  ; &div
    ex de,hl                    ; HL = &div, DE = rem.lo:mid
    ld a,e
    add a,(hl+)                 ; rem.lo + div.lo
    ld e,a
    ld a,d
    adc a,(hl+)                 ; rem.mid + div.mid
    ld d,a
    ld a,(hl)
    ld c,a                      ; C = div.hi
    pop hl                      ; rem high
    ld a,l
    adc a,c
    ld l,a
    ld a,h
    adc a,0
    ld h,a
    ex de,hl                    ; DE = high, HL = lo:mid
    ret

;=========================================================================
; Specials exits — m32_fszero / m32_fsmax take sign in D
;=========================================================================

.div_exp_bad_p
    pop af
    pop af
    jp div_exp_bad

.div_overflow_p
    pop af
    pop af
    jp div_overflow

.div_underflow_p
    pop af
    pop af
    jp div_underflow

.div_nan
    call drop_frame
    jp m32_fsconst_pnan

.div_a_inf
    ld de,sp+14
    call load4
    call m32_fpclassify
    cp 2
    jp Z,div_nan
    cp 3
    jp Z,div_nan
    ld de,sp+8
    ld a,(de)
    ld d,a
    call drop_frame
    call m32_fsmax
    or a                        ; clear error CF from m32_fseexit
    ret

.div_a_zero
    ld de,sp+14
    call load4
    call m32_fpclassify
    cp 2                        ; 0/NaN → NaN
    jp Z,div_nan
    dec a                       ; was zero? → 0/0 → NaN
    jp Z,div_nan
    ld de,sp+8
    ld a,(de)
    ld d,a
    call drop_frame
    jp m32_fszero               ; 0/num or 0/inf → signed 0

.div_b_inf
    ld de,sp+8
    ld a,(de)
    ld d,a
    call drop_frame
    jp m32_fszero

.div_b_zero
    ld de,sp+8
    ld a,(de)
    ld d,a
    call drop_frame
    call m32_fsmax
    or a
    ret

.div_exp_bad
    ld a,h
    rla
    jp C,div_underflow
.div_overflow
    ld de,sp+8
    ld a,(de)
    ld d,a
    call drop_frame
    call m32_fsmax
    or a
    ret

.div_underflow
    ld de,sp+8
    ld a,(de)
    ld d,a
    call drop_frame
    jp m32_fszero

; CALL-safe: SP = uret, work, sign, a, b, flag, cret [, orig_a].
; Drops work+sign+a+b+flag; restores uret so specials run.  Preserves D.
; Callee also drops orig_a under cret.
.drop_frame
    pop bc                      ; uret → specials
    ld hl,18                    ; work(8)+sign(2)+a(4)+b(4)
    add hl,sp
    ld sp,hl
    pop hl                      ; flag
    ld a,l
    or a
    jr NZ,drop_frame_callee
    push bc                     ; uret
    ret

.drop_frame_callee
    pop hl                      ; cret
    pop af
    pop af                      ; drop original a
    push hl                     ; cret
    push bc                     ; uret
    ret

;=========================================================================
; Entry helpers
;=========================================================================

.load4
    ex de,hl
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc
    ret

.ieee_unpack
    ex de,hl
    add hl,hl
    ld b,h
    ld a,l
    scf
    rra
    ex de,hl
    ret
