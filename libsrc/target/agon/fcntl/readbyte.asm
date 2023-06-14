SECTION code_clib
PUBLIC readbyte
PUBLIC _readbyte

INCLUDE "target/agon/def/mos_api.inc"

readbyte:
_readbyte:
    ld      c,l
    MOSCALL(mos_fgetc)	;preserves ix
    ld      hl,-1
    ret     c
    ld      l,a
    ld      h,0
    ret

