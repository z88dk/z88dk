; ZX Next MMU under z88dk-ticks -mz80n.
; 256 pages of 8 kB. A slot value of FF is the flat 64 kB image.
; Only slots 6 and 7 (0xC000 and 0xE000) are remapped. Slot 0 stays FF,
; so this code keeps running. Slots go back to FF before the stop, because
; -output reads through the final map.
; -banks loads zxn_page_BANK_10.bin into pages 0x10 and 0x11.
; Ten result bytes at 0x0200, above this program. Stop at 0x007e.

    org 0
    jp main
    defs $7e - $
stop:
    nop
    defs $80 - $
main:
    ld bc, $243b
    ld a, $56
    out (c), a
    ld bc, $253b
    in a, (c)
    ld ($200), a            ; FF, slot 6 is still the flat image

    nextreg $56, $20
    ld a, $11
    ld ($c000), a
    nextreg $56, $21
    ld a, $22
    ld ($c000), a
    nextreg $56, $20
    ld a, ($c000)
    ld ($201), a            ; 11
    nextreg $57, $20
    ld a, ($e000)
    ld ($202), a            ; 11, the same page in slot 7
    nextreg $56, $21
    ld a, ($c000)
    ld ($203), a            ; 22

    ld bc, $243b
    ld a, $56
    out (c), a
    ld bc, $253b
    ld a, $10
    out (c), a              ; the page loaded by -banks
    ld a, ($c000)
    ld ($204), a            ; A5
    ld a, ($c001)
    ld ($205), a            ; 5A
    in a, (c)
    ld ($206), a            ; 10, the slot reads back

    nextreg $56, $30
    ld hl, snippet
    ld de, $c000
    ld bc, 3
    ldir
    call $c000
    ld ($207), a            ; 42, code fetched from the bank

    nextreg $56, $ff
    nextreg $57, $ff
    ld a, $99
    ld ($c000), a           ; flat image, not page $20
    nextreg $56, $20
    ld a, ($c000)
    ld ($208), a            ; 11
    nextreg $56, $ff
    ld a, ($c000)
    ld ($209), a            ; 99
    jp stop

snippet:
    ld a, $42
    ret
