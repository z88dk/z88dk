SECTION code_clib
PUBLIC read
PUBLIC _read
PUBLIC ___read

INCLUDE "target/agon/def/mos_api.inc"

; ssize_t read(int fd, void *ptr, size_t len)
read:
_read:
___read:
    push    ix
    ld      ix,4
    add     ix,sp
    defb    $dd, $17, $00       ;ld de,(ix+0)
    defb    $dd, $27, $02       ;ld hl,(ix+2)
    ld      c,(ix+4)            ;fh
    MOSCALL(mos_fread)
    pop     ix
    ex      de,hl
    ret
