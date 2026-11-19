; RC2014 under z88dk-ticks -b rc2014.
; Port 0x38 is the standard 32 kB ROM page. The body is at 0x8000 so
; turning that ROM on does not move the fetches.
; Port 0x30 is shadow RAM on the SC108, the Memory Module, and the other
; 128 kB RAM boards. It switches the whole 64 kB, including the next
; instruction. The loaded image is in both RAM pages.
; Result bytes are stored while page 0 is selected. -output reads the final page.
; Six bytes at 0x8100. Stop at 0x807e.
; The image is assembled from address 0.

    org 0
    jp main
    defs $807e - $
stop:
    nop
    defs $8080 - $
main:
    ld a, $11
    ld ($4000), a           ; page 0
    ld a, 1
    out ($30), a            ; page 1
    ld a, $22
    ld ($4000), a
    xor a
    out ($30), a            ; page 0 before the result store
    ld a, ($4000)
    ld ($8100), a           ; 11

    ld a, 1
    out ($30), a
    ld a, ($4000)
    ld b, a                 ; 22
    xor a
    out ($30), a
    ld a, b
    ld ($8101), a

    ld a, $55
    out ($30), a            ; bit 0 set, other bits ignored: still page 1
    ld a, ($4000)
    ld b, a                 ; 22
    ld a, $54
    out ($30), a            ; bit 0 clear: page 0
    ld a, b
    ld ($8102), a
    ld a, ($4000)
    ld ($8103), a           ; 11

    ld a, $5a
    ld ($1000), a
    xor a
    out ($38), a            ; ROM on. Reads of 0x0000-0x7FFF come from the ROM.
    ld a, ($1000)
    ld b, a
    ld a, $a5
    ld ($1000), a           ; write-through to the RAM page
    ld a, 1
    out ($38), a            ; ROM off
    ld a, b
    ld ($8104), a           ; FF, empty ROM
    ld a, ($1000)
    ld ($8105), a           ; A5, the RAM byte

    jp stop

    ASSERT ($ < $8100)
