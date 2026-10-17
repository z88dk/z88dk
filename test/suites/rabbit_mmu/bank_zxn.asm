    org 0
    ld sp,0x8000
    nextreg 0x56,0x10      ; MMU slot 6 = page 0x10
    nextreg 0x57,0x11      ; MMU slot 7 = page 0x11
    ld hl,fn
    ld de,0xc000
    ld bc,3
    ldir                   ; ld a,0x42 ; ret  into the bank
    call 0xc000
    ld (0x0100),a
    nextreg 0x56,0xff      ; back to the flat image
    nextreg 0x57,0xff
done:
    nop
    jr $
fn:
    ld a,0x42
    ret
