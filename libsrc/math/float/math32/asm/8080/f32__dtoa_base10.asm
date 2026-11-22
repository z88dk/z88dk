;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_base10 — decimal conversion helper (stack-only, DEHL)
;-------------------------------------------------------------------------
;
; Convert x = a * 2^n to b * 10^e with 1 <= b < 10, then align the
; leading decimal digit into D[7:4].  Same 77n+5 estimate as the Z80
; helper; float lives in DEHL (not DEHL').

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_float8, _m32_exp10f, m32_fsmul, m32_fsmul10u_fastcall
EXTERN m32_fsdiv

PUBLIC m32__dtoa_base10


.m32__dtoa_base10
    ; enter : dehl = double x, x positive
    ;
    ; exit  : dehl = aligned mantissa (top 4 bits of D = first decimal digit)
    ;            b = base 10 exponent e
    ;            c = max significant decimal digits (8)
    ;
    ; uses  : af, bc, de, hl

    push de
    push hl                         ; save x

    ; exp = (D << 1) | (E >> 7), sign already cleared
    ld a,e
    add a,a
    ld a,d
    rla                             ; A = n+bias

    sub 07eh                        ; remove excess (bias-1)
    ld l,a
    rla
    sbc a,a
    ld h,a                          ; hl = signed n

    push hl                         ; n
    add hl,hl
    add hl,hl
    push hl                         ; 4*n
    add hl,hl
    ld bc,hl                        ; bc = 8*n
    add hl,hl
    add hl,hl
    add hl,hl                       ; 64*n
    add hl,bc                       ; 72*n
    pop bc
    add hl,bc                       ; 76*n
    pop bc
    add hl,bc                       ; 77*n
    ld bc,5
    add hl,bc                       ; +5

    ld a,h                          ; e = INT((77*n+5)/256)
    pop hl
    pop de                          ; DEHL = x
    push af                         ; save e

    or a
    jp Z,e_done                     ; 10^0 = 1, b = x
    jp M,e_negative

    ; e >= 0: b = x / 10^e
    push de
    push hl                         ; x = a for fsdiv
    ld l,a
    call m32_float8
    call _m32_exp10f                ; DEHL = 10^e = b
    call m32_fsdiv                  ; DEHL = a/b, a remains
    inc sp
    inc sp
    inc sp
    inc sp                          ; drop a (AF-safe)
    jp e_done

.e_negative
    neg                             ; |e|
    push de
    push hl                         ; x = a for fsmul
    ld l,a
    call m32_float8
    call _m32_exp10f
    call m32_fsmul
    inc sp
    inc sp
    inc sp
    inc sp

.e_done
    ; DEHL = b
    ld a,e
    add a,a
    ld a,d
    rla                             ; A = remaining exp, DEHL unchanged

    cp 07fh                         ; remaining fraction part < 1 ?
    jp NC,aligned_digit

    pop af
    dec a
    push af
    call m32_fsmul10u_fastcall

.aligned_digit
    ; 1 <= b < 10.  Align the leading decimal nibble into D[7:4].
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a                          ; rl de, D = exp
    scf
    ld a,e
    rra
    ld e,a                          ; restore hidden bit

    ld a,07eh+4
    sub d                           ; extra right shifts (0..3)
    ld b,a

    ld d,e
    ld e,h
    ld h,l
    ld l,0
    jp Z,rotation_done

.digit_loop
    or a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec b
    jp NZ,digit_loop

.rotation_done
    pop af                          ; e
    ld b,a
    ld c,8
    ret
