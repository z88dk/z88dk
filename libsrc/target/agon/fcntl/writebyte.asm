SECTION code_clib
PUBLIC writebyte
PUBLIC _writebyte
PUBLIC ___writebyte

INCLUDE "target/agon/def/mos_api.inc"

;int writebyte(int fd, int byte)
writebyte:
_writebyte:
___writebyte:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      b,(ix+0)    ;byte to write
    ld      c,(ix+2)    ;file
    MOSCALL(mos_fputc)
    pop     ix
    ld      hl,0
    ret