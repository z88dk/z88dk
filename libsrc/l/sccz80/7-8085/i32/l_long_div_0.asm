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
; so they are batch-shifted; remaining iterations use the original body.
;
; DIV16_FASTPATH selects the register-based 16-bit-divisor path at the end of
; this file.  Set it to 0 to build the generic loop alone, which is byte for byte
; what this file was before the fast path existed.  Measured on the 8085, pi.c:
; off 7_375_640_847, on 2_744_570_287, for 86 bytes.
;
; The switch is here because the same argument applies to a 24-bit divisor (the
; remainder is then provably under 2^24, so the three memory walks narrow from
; four bytes to three, worth about a fifth of the generic loop), so this may yet
; become one width dispatch rather than one special case — as it already is on
; the z80 side, where l_fast_divu_32_32x16/24/8 sits behind __CLIB_OPT_IMATH.

defc DIV16_FASTPATH = 1

.l_long_div_0
    ;----- compute skip = bitlen(divisor) - 1; B = 32 - skip -----
    ld      de,sp+10
    ld      a,(de+)
    ld      c,a
    ld      a,(de)
    ld      b,a                 ; BC = div MSW
    or      c
    ld      e,16                ; E = 16 if MSW half, else 0
    jp      nz,half_ready
    IF DIV16_FASTPATH
    jp      div16               ; MSW == 0 -> the 16-bit-divisor fast path
    ENDIF
    ld      de,sp+8
    ld      a,(de+)
    ld      c,a
    ld      a,(de)
    ld      b,a                 ; BC = div LSW
    or      c
    jp      z,full_32           ; div 0 → full width
    ld      e,0
.half_ready
    ; BC = nonzero half; E = 0 or 16
    ; Find bitlen within half using left shifts into Carry.
    ; Counter in D (1..16). 8085 has no rl b — shift B via A.
    ld      d,16
.scan
    ld      a,c
    add     a,a                 ; sla c (8085: no CB-prefix sla)
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
    inc     a                   ; A = remaining iterations = 33 - bitlen
    ld      b,a                 ; B = remaining full iterations
    ld      a,c
    dec     a                   ; A = skip
    jp      z,pre_loop          ; bitlen==1 → no batch
    ld      c,a                 ; C = skip count
    or      a                   ; clear Carry (first qbit in = 0)

    ;----- batch skip shift-only steps (qbit always 0) -----
.batch
    ld      de,sp+14
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

    ld      de,sp+4
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

    xor     a                   ; C flag = 0 for next qbit
    dec     c
    jp      nz,batch
    jp      div_loop            ; B = remaining; C flag = 0

.full_32
    ld      b,32
.pre_loop
    or      a                   ; clear Carry

    ;----- main restoring loop (original body) -----
.div_loop
    ld      de,sp+14
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

    ld      de,sp+4
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

    ld      de,sp+8
    ex      de,hl
    ld      de,sp+4

    ld      a,(de+)
    sub     a,(hl+)
    ld      a,(de+)
    sbc     a,(hl+)
    ld      a,(de+)
    sbc     a,(hl+)
    ld      a,(de)
    sbc     a,(hl)

    jp      c,skip_subtract

    ld      de,sp+8
    ex      de,hl
    ld      de,sp+4

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
    ccf
    dec     b
    jp      nz,div_loop

    ;----- final quotient bit into dividend -----
    ld      de,sp+14
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

    ret

    IF DIV16_FASTPATH
;===============================================================================
; 16-bit-divisor fast path.  Taken whenever the divisor's MSW is zero, which is
; the common case in C (dividing a long by an int or a small constant).
;
; The generic body below has to keep the 32-bit dividend/quotient, remainder and
; divisor — 12 bytes — so on a CPU with no alternate register set it shuttles all
; of them through memory: ~40 memory accesses per quotient bit.  With a 16-bit
; divisor the state is 4 + 2 + 2 = 8 bytes and the remainder is at most 17 bits,
; so the whole loop fits in registers and uses the instructions the 8085 has for
; exactly this: RDEL to shift the remainder with carry in, and DSUB to trial
; subtract.  ~78 cycles per bit against ~340.
;
;   A  = bit counter (16 per pass)      BC = divisor
;   DE = running remainder              HL = dividend half -> quotient half
;
; Two passes of 16 bits (MSW then LSW) carry the remainder across in DE, which is
; ordinary long division 16 bits at a time.  Invariant: R < D before each shift,
; so R17 = 2R + bit < 2D; when R17 overflows 16 bits (only possible for
; D > 0x8000) the subtract is unconditional and the 16-bit wrap of HL-BC IS
; R17-D, because R17-D < D <= 0xFFFF.
;===============================================================================
.div16
    ld      de,sp+8
    ld      hl,(de)
    ld      bc,hl               ; BC = divisor (MSW known zero)
    ld      a,c
    or      b
    jp      z,full_32           ; divisor 0 -> generic path handles it

    ld      de,sp+16
    ld      hl,(de)             ; HL = dividend MSW
    ld      de,0                ; remainder = 0
    call    d16_pass            ; -> HL = quotient MSW, DE = remainder

    push    hl                  ; save quotient MSW          (sp shifts +2)
    push    de                  ; save remainder             (sp shifts +4)
    ld      de,sp+18            ; dividend LSW (14 + 4)
    ld      hl,(de)
    pop     de                  ; remainder back             (sp +2)
    call    d16_pass            ; -> HL = quotient LSW, DE = final remainder

    ld      bc,hl               ; park quotient LSW (divisor dead)
    ld      hl,de               ; HL = remainder
    ld      de,sp+6             ; remainder LSW slot (4 + 2)
    ld      (de),hl
    ld      hl,0
    ld      de,sp+8             ; remainder MSW slot (6 + 2) - always zero
    ld      (de),hl
    ld      hl,bc
    ld      de,sp+16            ; quotient LSW slot (14 + 2)
    ld      (de),hl
    pop     hl                  ; quotient MSW               (sp +0)
    ld      de,sp+16            ; quotient MSW slot
    ld      (de),hl
    ret

; One 16-bit pass.  HL = dividend half in, quotient half out; DE = remainder in
; and out; BC = divisor; A destroyed.  NB no sp-relative access in here - the
; call has shifted sp by 2.
.d16_pass
    ld      a,16
    or      a                   ; clear carry: first quotient bit is 0
.d16_loop
    add     hl,hl               ; Q <<= 1 (bit 0 clear), CF = dividend MSB
    rl      de                  ; R = (R<<1)|CF, CF = R bit 16
    jp      c,d16_force
    ex      de,hl               ; HL = R, DE = Q
    sub     hl,bc               ; R - D
    jp      c,d16_restore       ; borrow: R < D, quotient bit 0
    ex      de,hl               ; DE = R', HL = Q
    inc     hl                  ; quotient bit 1
.d16_next
    dec     a
    jp      nz,d16_loop
    ret
.d16_restore
    add     hl,bc               ; undo the trial subtract
    ex      de,hl
    jp      d16_next
.d16_force
    ex      de,hl               ; R had bit 16: subtract unconditionally
    sub     hl,bc
    ex      de,hl
    inc     hl
    jp      d16_next

    ENDIF
