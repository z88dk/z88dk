    SECTION code_clib
	PUBLIC	cleargraphics
	PUBLIC   _cleargraphics

cleargraphics:
_cleargraphics:
loop40:
    in a,(0x40)
    and 0x80
    jp nz,loop40
    ld a,0x40; set startline to 0
    out (0x40),a
    xor a
    ld b,24*8
    ld de,0
    call 0xbfee
    ret
