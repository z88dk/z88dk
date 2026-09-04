;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv — 8080 restoring IEEE single divide
;-------------------------------------------------------------------------
;
; Stack-only (no exx / IX / djnz / 8085 extras).
;
; Hot path:
;   DEHL     = rem (L=lo H=mid E=hi D=x)
;   B        = bit count
;   work+0..2 = div (lo,mid,hi)
;
; rem <<= 1 : add hl,hl / rla through A (no rl de)
; trial     : rem_sub / rem_add
; C-save    : rra / ld hl,sp+n / rla around quot shift
;
; Specials: classify then unpack.
; Algebra: a/0→±Inf (0/0→NaN); finite/Inf→±0; Inf/Inf→NaN; NaN/*→NaN.
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

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fpclassify
EXTERN m32_fszero, m32_fsmax
EXTERN m32_fsconst_pnan

PUBLIC m32_fsdiv, m32_fsdiv_callee


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
    push hl                     ; b
    ld hl,sp+8
    call load4                  ; DEHL = a
    push de
    push hl                     ; a

    ld hl,sp+3
    ld c,(hl)                   ; a.sign|exp
    ld hl,sp+7
    ld a,(hl)                   ; b.sign|exp
    xor c
    and 080h
    ld l,a
    ld h,0
    push hl                     ; sign

    ld hl,-8
    add hl,sp
    ld sp,hl
    ; work@0  sign@8  a@10  b@14  flag@18  ret@20

    ld hl,sp+10
    call load4                      ; DEHL = a
    call m32_fpclassify             ; A = 0 num, 1 zero, 2 nan, 3 inf
    cp 2
    jp Z,div_nan
    cp 3
    jp Z,div_a_inf
    dec a
    jp Z,div_a_zero

    ld hl,sp+14
    call load4                      ; DEHL = b
    call m32_fpclassify             ; A = class(b)
    cp 2
    jp Z,div_nan
    cp 3
    jp Z,div_b_inf
    dec a
    jp Z,div_b_zero

    ld hl,sp+10
    call load4
    call ieee_unpack            ; B=exp_a A=mhi HL=mlo
    ld c,a
    push hl                     ; mlo
    ld hl,sp+5                  ; expR at +3+2
    ld (hl),b
    pop hl
    ld e,c
    ld d,0
    push de
    push hl                     ; rem high, rem low

    ld hl,sp+18                 ; b at +14+4
    call load4
    call ieee_unpack            ; B=exp_b A=mhi HL=mlo
    ld c,a                      ; mhi
    ld a,l
    ld e,h                      ; E = mid
    ld hl,sp+4                  ; &div (work at +4 under rem)
    ld (hl+),a
    ld (hl+),e
    ld (hl),c                   ; div hi

    ld hl,sp+7
    ld a,(hl)
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
    ld c,a
    ld hl,sp+7
    ld (hl),c

    pop hl
    pop de                      ; rem
    push de
    push hl                     ; park rem; L is rem low
    xor a
    ld hl,sp+8                  ; quot at +4 +4
    ld (hl+),a
    ld (hl+),a
    ld (hl),a                   ; quot = 0
    pop hl
    pop de                      ; rem

    call rem_sub
    jr C,div_pre_lt
    call rem_add
    jr div_prenorm_done

.div_pre_lt
    call rem_add
    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
    push de
    push hl
    ld hl,sp+7                  ; expR at +3 +4
    ld a,(hl)
    dec a
    ld (hl),a
    pop hl
    pop de
.div_prenorm_done

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
    rra                         ; C → A.7 (ld hl,sp+n clobbers C)
    ld hl,sp+8                  ; &quot at +4 +4
    rla                         ; C restored
    ld a,(hl)
    rla
    ld (hl+),a
    ld a,(hl)
    rla
    ld (hl+),a
    ld a,(hl)
    rla
    ld (hl),a
    pop hl
    pop de

    add hl,hl
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a

    dec b
    jp NZ,div_bit_loop

    call rem_sub
    jr C,div_guard_restore

    ld a,l
    or h
    or e
    or d
    jr NZ,div_round_up
    ld hl,sp+4
    ld a,(hl)
    and 1
    jr Z,div_guard_done
.div_round_up
    ld hl,sp+4
    ld a,(hl)
    inc a
    ld (hl+),a                  ; NZ from inc a (ld/inc hl keep flags)
    jr NZ,div_guard_done
    ld a,(hl)
    inc a
    ld (hl+),a                  ; NZ from inc a
    jr NZ,div_guard_done
    ld a,(hl)
    inc a
    ld (hl),a                   ; NZ from inc a
    jr NZ,div_guard_done
    ld a,080h
    ld (hl),a
    ld hl,sp+3
    ld a,(hl)
    inc a
    ld (hl),a
    jr div_guard_done

.div_guard_restore
    call rem_add
.div_guard_done

    ld hl,sp+6
    ld b,(hl)                   ; B = quot.hi
    ld hl,sp+4
    ld e,(hl+)
    ld d,(hl)
    ex de,hl                    ; HL = quot.lo:mid

    ld a,b
    or a
    rla
    jr C,div_pack
    add hl,hl
    ld a,b
    rla
    ld b,a
    push hl
    ld hl,sp+5                  ; expR at +3+2
    ld a,(hl)
    dec a
    ld (hl),a
    pop hl
.div_pack
    push hl                     ; park quot.lo:mid
    ld hl,sp+5                  ; expR at +3+2
    ld a,(hl)
    or a
    jp Z,div_underflow_q
    cp 255
    jp NC,div_overflow_q
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
    ld hl,sp+10                 ; sign at +8+2
    ld a,(hl)
    and 080h
    or c
    ld d,a
    ld e,b
    pop hl                      ; DEHL = packed IEEE

    ld bc,hl
    ld hl,18
    add hl,sp
    ld sp,hl
    pop hl                      ; flag
    ld a,l
    ld hl,bc
    or a
    jr Z,div_done
    pop bc                      ; cret
    pop af
    pop af
    push bc
.div_done
    ret

.div_underflow_q
    pop hl                      ; drop parked quot
    jp div_underflow

.div_overflow_q
    pop hl
    jp div_overflow

;=========================================================================
; rem_sub / rem_add — CALL SP=work; B=count; DEHL=rem; div@work+0
; Preserves B (bit count).  C holds div.hi for the last sbc/adc.
; lo/mid use sub (hl) / sbc a,(hl) so C stays free until div.hi.
; Parks rem.high; pointer in HL.
;=========================================================================

.rem_sub
    push de                     ; rem high
    ld de,hl                    ; DE = rem mid:lo
    ld hl,sp+4                  ; &div
    ld a,e
    sub (hl+)                   ; rem.lo - div.lo
    ld e,a
    ld a,d
    sbc a,(hl+)                 ; rem.mid - div.mid
    ld d,a
    ld a,(hl)
    ld c,a                      ; C = div.hi (do not pop rem high into BC)
    pop hl                      ; rem high
    ld a,l
    sbc a,c
    ld l,a
    ld a,h
    sbc a,0
    ld h,a
    ex de,hl                    ; DE = high, HL = low
    ret

.rem_add
    push de                     ; rem high
    ld de,hl                    ; DE = rem mid:lo
    ld hl,sp+4                  ; &div
    ld a,e
    add a,(hl+)                 ; rem.lo + div.lo
    ld e,a
    ld a,d
    adc a,(hl+)                 ; rem.mid + div.mid
    ld d,a
    ld a,(hl)
    ld c,a                      ; C = div.hi (B is bit count)
    pop hl                      ; rem high
    ld a,l
    adc a,c
    ld l,a
    ld a,h
    adc a,0
    ld h,a
    ex de,hl                    ; DE = high, HL = low
    ret

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
    ld hl,sp+14
    call load4
    call m32_fpclassify
    cp 2
    jp Z,div_nan
    cp 3
    jp Z,div_nan
    ld hl,sp+8
    ld d,(hl)                   ; sign for ±Inf
    call drop_frame             ; D kept; SP restored
    call m32_fsmax              ; DEHL = signed Inf from D.7
    or a
    ret

.div_a_zero
    ld hl,sp+14
    call load4
    call m32_fpclassify
    cp 2
    jp Z,div_nan
    dec a
    jp Z,div_nan
    ld hl,sp+8
    ld d,(hl)                   ; sign for ±0
    call drop_frame             ; D kept; SP restored
    jp m32_fszero               ; DEHL = signed 0 from D.7

.div_b_inf
    ld hl,sp+8
    ld d,(hl)                   ; sign for ±0
    call drop_frame             ; D kept; SP restored
    jp m32_fszero               ; DEHL = signed 0 from D.7

.div_b_zero
    ld hl,sp+8
    ld d,(hl)                   ; sign for ±Inf
    call drop_frame             ; D kept; SP restored
    call m32_fsmax              ; DEHL = signed Inf from D.7
    or a
    ret

.div_exp_bad
    ld a,h
    rla
    jp C,div_underflow
.div_overflow
    ld hl,sp+8
    ld d,(hl)                   ; sign for ±Inf
    call drop_frame             ; D kept; SP restored
    call m32_fsmax              ; DEHL = signed Inf from D.7
    or a
    ret

.div_underflow
    ld hl,sp+8
    ld d,(hl)                   ; sign for ±0
    call drop_frame             ; D kept; SP restored
    jp m32_fszero               ; DEHL = signed 0 from D.7

.drop_frame
    pop bc                      ; uret
    ld hl,18
    add hl,sp
    ld sp,hl
    pop hl                      ; flag
    ld a,l
    or a
    jr NZ,drop_frame_callee
    push bc
    ret

.drop_frame_callee
    pop hl                      ; cret
    pop af
    pop af
    push hl
    push bc
    ret

.load4
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
