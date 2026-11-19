; Read five IDE LBAs and print eight bytes from each sector.
; The hook takes the LBA in BCHL, L the least significant byte.
; The buffer is at 0x8000, above the RC2014 ROM window.
; CMD_IDE_SELECT is 40. CMD_IDE_READ is 42.

    org 0

    ld a, 40
    ld l, 0
    call hook

    ld hl, table
next:
    ld a, (hl)
    inc hl
    cp $ff
    jp z, done
    ld b, a
    ld c, (hl)
    inc hl
    ld d, (hl)
    inc hl
    ld e, (hl)
    inc hl
    push hl
    ld h, d
    ld l, e
    ld de, $8000
    ld a, 42
    call hook
    jp c, bad
    call print8
    pop hl
    jp next

done:
    jp stop

bad:
    ld hl, errmsg
perr:
    ld a, (hl)
    or a
    jp z, badexit
    push hl
    ld l, a
    ld a, 1
    call hook
    pop hl
    inc hl
    jp perr
badexit:
stop:
    ASSERT $ == $44
    nop

hook:
    defb $ed, $fe
    ret

print8:
    ld hl, $8000
    ld b, 8
p8:
    push bc
    push hl
    ld l, (hl)
    ld a, 1
    call hook
    pop hl
    pop bc
    inc hl
    djnz p8
    ld l, 10
    ld a, 1
    call hook
    ret

; Each row is B, C, H, L. $FF ends the table.
table:
    defb $00, $3f, $ff, $ff
    defb $00, $40, $00, $00
    defb $00, $7f, $ff, $ff
    defb $00, $80, $00, $00
    defb $0f, $ff, $ff, $ff
    defb $ff

errmsg:
    defm "ERR"
    defb 10, 0
