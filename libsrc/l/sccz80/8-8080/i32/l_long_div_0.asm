;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021 7/2026

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_div_0

; Stack on entry (unchanged contract):
;   +0   return to wrapper
;   +2   sign word
;   +4   remainder LSW  (out)
;   +6   remainder MSW  (out)
;   +8   divisor LSW
;   +10  divisor MSW
;   +12  caller's return
;   +14  dividend/quotient LSW (in/out)
;   +16  dividend/quotient MSW (in/out)
;
; First (bitlen(D)-1) restoring steps never subtract (R has too few bits),
; so they are batch-shifted; remaining iterations use the restoring body.
;
; DIV16_FASTPATH selects the register-based 16-bit-divisor path at the end of
; this file.  Set it to 0 to build the generic loop alone, which is byte for byte
; what this file was before the fast path existed.  Measured on the 8080, imath
; suite: off 9_806_542, on 5_343_372.
;
; The switch is here because the same argument applies to a 24-bit divisor (the
; remainder is then provably under 2^24, so the three memory walks narrow from
; four bytes to three, worth about a fifth of the generic loop), so this may yet
; become one width dispatch rather than one special case — as it already is on
; the z80 side, where l_fast_divu_32_32x16/24/8 sits behind __CLIB_OPT_IMATH.

defc DIV16_FASTPATH = 1

.l_long_div_0
    ;----- compute skip = bitlen(divisor) - 1; B = 32 - skip -----
    ld      hl,sp+10
    ld      a,(hl+)
    ld      c,a
    ld      a,(hl)
    ld      b,a                 ; BC = div MSW
    or      c
    ld      e,16                ; E = 16 if MSW half, else 0
    jp      nz,half_ready
    IF DIV16_FASTPATH
    jp      div16               ; MSW == 0 -> the 16-bit-divisor fast path
    ENDIF
    ld      hl,sp+8
    ld      a,(hl+)
    ld      c,a
    ld      a,(hl)
    ld      b,a                 ; BC = div LSW
    or      c
    jp      z,full_32           ; div 0 → full width
    ld      e,0
.half_ready
    ; BC = nonzero half; E = 0 or 16
    ; Find bitlen within half (no sla/rl r on 8080 — use A)
    ld      d,16
.scan
    ld      a,c
    add     a,a                 ; sla c
    ld      c,a
    ld      a,b
    adc     a,a                 ; rl b
    ld      b,a
    jp      c,scan_hit
    dec     d
    jp      nz,scan
    ld      d,1                 ; should not happen
.scan_hit
    ; D = bitlen in half (1..16); total bitlen = D + E
    ld      a,d
    add     e                   ; A = bitlen (1..32)
    ld      c,a                 ; C = bitlen
    ld      a,32
    sub     c                   ; A = 32 - bitlen
    inc     a                   ; A = remaining = 33 - bitlen
    ld      b,a                 ; B = remaining full iterations
    ld      a,c
    dec     a                   ; A = skip
    jp      z,pre_loop          ; bitlen==1 → no batch
    ld      c,a                 ; C = skip count
    or      a                   ; clear Carry (first qbit in = 0)

    ;----- batch skip shift-only steps (qbit always 0) -----
    ; ld hl,sp+* is add hl,sp — clobbers Carry; clear C after each setup.
.batch
    ld      hl,sp+14
    or      a                   ; qbit in = 0 (after sp math)
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl),a              ; C = bit into remainder

    rra                         ; save C across ld hl,sp+*
    ld      hl,sp+4
    rla
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl),a

    xor     a                   ; C flag = 0 for next qbit
    dec     c
    jp      nz,batch
    jp      div_loop            ; B = remaining; C flag = 0

.full_32
    ld      b,32
.pre_loop
    or      a                   ; clear Carry

    ;----- main restoring loop -----
.div_loop
    rra                         ; save Carry
    ld      hl,sp+4             ; remainder (hl)
    ex      de,hl
    ld      hl,sp+14            ; dividend (hl)
    rla                         ; restore Carry

    ; rotate left dividend + quotient Carry
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl),a

    ; rotate left remainder + dividend Carry
    ld      a,(de)
    rla
    ld      (de+),a
    ld      a,(de)
    rla
    ld      (de+),a
    ld      a,(de)
    rla
    ld      (de+),a
    ld      a,(de)
    rla
    ld      (de),a

    ; compare (remainder - divisor)
    ld      hl,sp+4
    ex      de,hl
    ld      hl,sp+8

    ld      a,(de+)
    sub     a,(hl+)
    ld      a,(de+)
    sbc     a,(hl+)
    ld      a,(de+)
    sbc     a,(hl+)
    ld      a,(de)
    sbc     a,(hl)

    jp      c,skip_subtract

    ; subtract (remainder - divisor)
    ld      hl,sp+4
    ex      de,hl
    ld      hl,sp+8

    ld      a,(de)
    sub     a,(hl+)
    ld      (de+),a
    ld      a,(de)
    sbc     a,(hl+)
    ld      (de+),a
    ld      a,(de)
    sbc     a,(hl+)
    ld      (de+),a
    ld      a,(de)
    sbc     a,(hl)
    ld      (de),a

.skip_subtract
    ccf                         ; prepare Carry for quotient

    dec     b
    jp      nz,div_loop

    ; final quotient bit into dividend
    rra                         ; save Carry
    ld      hl,sp+14
    rla                         ; restore Carry

    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl+),a
    ld      a,(hl)
    rla
    ld      (hl),a

    ret

    IF DIV16_FASTPATH
;===============================================================================
; 16-bit-divisor fast path.  Taken whenever the divisor's MSW is zero, which is
; the common case in C (dividing a long by an int or a small constant).
;
; Same two-pass shape as the 8085 path: remainder in DE, dividend/quotient half
; in HL, divisor in BC.  8080 has no RDEL / DSUB, so the inner loop is the
; l_div / l_cmpbcde trial: rotate DE through A, compare in A (does not write
; DE), subtract only when R >= D.  The bit count sits on the stack, as in
; l_div, because A is the ALU.  When the shifted remainder overflows 16 bits
; (only possible for D > 0x8000) the subtract is unconditional and the 16-bit
; wrap of DE-BC IS R17-D, because R17-D < D.
;===============================================================================
.div16
    ld      hl,sp+8
    ld      a,(hl+)
    ld      c,a
    ld      a,(hl)
    ld      b,a                 ; BC = divisor (MSW known zero)
    or      c
    jp      z,full_32           ; divisor 0 -> generic path handles it

    ld      hl,sp+16
    ld      a,(hl+)
    ld      e,a
    ld      a,(hl)
    ld      d,a
    ex      de,hl               ; HL = dividend MSW
    ld      a,l
    sub     c
    ld      a,h
    sbc     a,b
    jp      nc,d16_msw_ge       ; MSW >= D: need a real first pass
    ld      de,hl               ; rem = MSW
    ld      hl,0                ; quot MSW = 0
.d16_have_msw
    ; HL = quot MSW, DE = rem.  Write MSW now so the second pass sits
    ; on the original frame (no stacked quot).
    push    de                  ; rem                              (sp +2)
    ex      de,hl               ; DE = quot MSW
    ld      hl,sp+18            ; quot MSW slot (16 + 2)
    ld      a,e
    ld      (hl+),a
    ld      a,d
    ld      (hl),a
    ld      hl,sp+16            ; dividend LSW (14 + 2)
    ld      a,(hl+)
    ld      e,a
    ld      a,(hl)
    ld      d,a
    ex      de,hl
    pop     de                  ; rem
    call    d16_pass            ; -> HL = quot LSW, DE = rem

    ld      bc,hl               ; park quot LSW (divisor dead)
    ld      hl,sp+4             ; remainder LSW
    ld      a,e
    ld      (hl+),a
    ld      a,d
    ld      (hl+),a
    xor     a
    ld      (hl+),a             ; remainder MSW - always zero
    ld      (hl),a
    ld      hl,sp+14            ; quot LSW
    ld      a,c
    ld      (hl+),a
    ld      a,b
    ld      (hl),a
    ret

.d16_msw_ge
    ld      de,0
    call    d16_pass            ; -> HL = quot MSW, DE = rem
    jp      d16_have_msw

; One 16-bit pass.  HL = dividend half in, quotient half out; DE = remainder in
; and out; BC = divisor; A destroyed.  NB no sp-relative access in here - the
; call has shifted sp by 2.  The bit count sits on the stack, as in l_div:
; A is the 8-bit ALU.  Force and success share one subtract; sub ignores the
; overflow carry so the 16-bit wrap of DE-BC is R17-D.
.d16_pass
    ld      a,16
.d16_loop
    push    af
    add     hl,hl               ; Q <<= 1 (bit 0 clear), CF = dividend MSB
    ld      a,e
    rla
    ld      e,a
    ld      a,d
    rla
    ld      d,a                 ; R = (R<<1)|CF, CF = R bit 16
    jp      c,d16_force
    ld      a,e
    sub     c
    ld      a,d
    sbc     a,b
    jp      c,d16_next          ; borrow: R < D, quotient bit 0
.d16_force
    ld      a,e
    sub     c
    ld      e,a
    ld      a,d
    sbc     a,b
    ld      d,a
    inc     hl                  ; quotient bit 1
.d16_next
    pop     af
    dec     a
    jp      nz,d16_loop
    ret

    ENDIF
