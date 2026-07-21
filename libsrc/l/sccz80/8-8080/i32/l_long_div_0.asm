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
