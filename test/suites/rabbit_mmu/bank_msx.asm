    org 0
    ld sp,0x4000
    ld a,5
    out (0xfe),a           ; page 5 at 0x8000
    ld hl,fn
    ld de,0x8000
    ld bc,3
    ldir                   ; ld a,0x42 ; ret  into the page
    call 0x8000
    ld (0x0100),a
    ld a,2
    out (0xfe),a           ; back to the 64k image
done:
    nop
    jr $
fn:
    ld a,0x42
    ret
