    SECTION code_clib
	PUBLIC	cleargraphics
	PUBLIC   _cleargraphics

cleargraphics:
_cleargraphics:
    xor a
    ld b,24*6
    ld de,0
    call 0xbfee
    ret
