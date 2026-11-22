; Z180 MMU under z88dk-ticks. Results are 20 bytes at 0x0100.
; Stop at 0x007e. Run with -mz180. -mz180 selects the z180 model.
;
; Reset CBAR is F0: pages 0-E follow BBR, page F follows CBR.
; A BBR write is fetched from the new bank, so every BBR change runs at
; 0xF000 with CBR left at 0. A CBR write runs from the low bank area.
; The map is put back (CBAR F0, BBR 0, CBR 0) before the stop. -output
; reads through the final map. ICR may stay at C0.

    org 0
    jp main
    defs $7e - $
stop:
    nop
    defs $80 - $
main:
    in0 a, ($3a)
    ld ($100), a            ; reset CBAR is F0

    ld a, $11
    ld ($1000), a
    ld a, $22
    ld ($8000), a
    ld a, $33
    ld ($fe00), a           ; common 1, above the routine at 0xF000
    ld a, ($1000)
    ld ($101), a            ; 11, bank area, BBR 0
    ld a, ($8000)
    ld ($102), a            ; 22
    ld a, ($fe00)
    ld ($103), a            ; 33

    ld a, $20
    out0 ($38), a           ; CBR = 20. PC is still in the bank area.
    ld a, $5a
    ld ($fe10), a
    xor a
    out0 ($38), a
    ld a, ($fe10)
    ld ($106), a            ; 00, that byte is not in the low 64k
    ld a, $20
    out0 ($38), a
    ld a, ($fe10)
    ld b, a
    xor a
    out0 ($38), a
    ld a, b
    ld ($107), a            ; 5a

    ld a, $84
    out0 ($3a), a           ; common 0 below 0x4000, so 0x1000 ignores BBR
    ld a, $77
    ld ($1000), a
    ld a, ($1000)
    ld ($108), a            ; 77
    ld a, $f0
    out0 ($3a), a
    jp high

    defs $f000 - $
high:
    ld a, $10
    out0 ($39), a           ; BBR = 10. Page F stays put while CBR is 0.
    ld a, $a5
    ld ($2000), a
    xor a
    out0 ($39), a
    ld a, ($2000)
    ld ($104), a            ; 00
    ld a, $10
    out0 ($39), a
    ld a, ($2000)
    ld b, a
    xor a
    out0 ($39), a
    ld a, b
    ld ($105), a            ; a5

    ld a, $84
    out0 ($3a), a           ; page F is still common 1
    ld a, $30
    out0 ($39), a
    ld a, $66
    ld ($4000), a
    xor a
    out0 ($39), a
    ld a, ($4000)
    ld b, a
    ld a, $30
    out0 ($39), a
    ld a, ($4000)
    ld c, a
    xor a
    out0 ($39), a
    ld a, $f0
    out0 ($3a), a
    ld a, b
    ld ($109), a            ; 00
    ld a, c
    ld ($10a), a            ; 66

    ld a, $ff
    out0 ($39), a           ; BBR FF, logical 0x8000 wraps to physical 0x7000
    ld a, $44
    ld ($8000), a
    xor a
    out0 ($39), a
    ld a, ($7000)
    ld ($10b), a            ; 44
    ld a, ($8000)
    ld ($10c), a            ; 22, the first store is still there

    ld a, $3c
    out0 ($39), a
    in0 a, ($39)
    ld b, a
    xor a
    out0 ($39), a
    ld a, b
    ld ($10d), a            ; 3c

    ld bc, $0039
    ld a, $21
    out (c), a              ; OUT (C) hits BBR while ICR is 0
    in0 a, ($39)
    ld b, a
    xor a
    out0 ($39), a
    ld a, b
    ld ($10e), a            ; 21

    ld a, $c0
    out0 ($3f), a           ; ICR relocates internal I/O to 0xC0
    ld a, $55
    out0 ($39), a           ; this port is no longer BBR
    in0 a, ($f9)
    ld ($10f), a            ; 00
    ld a, $12
    out0 ($f9), a
    in0 a, ($f9)
    ld b, a
    xor a
    out0 ($f9), a           ; BBR 0 so the result lands in the low 64k
    ld a, b
    ld ($110), a            ; 12
    in0 a, ($39)
    ld ($111), a            ; FF, not an internal register

    ld a, $07
    out0 ($f9), a
    in0 l, ($39)            ; ED 28. ICR is still C0, so this is not BBR
    ld b, l
    in0 l, ($f9)
    xor a
    out0 ($f9), a
    ld a, b
    ld ($112), a            ; FF from the missed port
    ld a, l
    ld ($113), a            ; 07 from BBR

    jp stop

    ASSERT ($ < $FE00)
