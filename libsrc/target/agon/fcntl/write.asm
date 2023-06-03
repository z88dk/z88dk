SECTION code_clib
PUBLIC write
PUBLIC _write
EXTERN  __agon_hl24

INCLUDE "target/agon/def/mos_api.inc"

; ssize_t write(int fd, void *ptr, size_t len)
write:
_write:
    push    ix
    ld      ix,4
    add     ix,sp
    defb    $dd, $17, $00       ;ld de,(ix+0)
    defb    $dd, $27, $02       ;ld hl,(ix+2)
    call    __agon_hl24
    ld      c,(ix+4)            ;fh
    MOSCALL(mos_fwrite)
    pop     ix
    ex      de,hl
    ret
