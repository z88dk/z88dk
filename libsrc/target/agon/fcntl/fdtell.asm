

    SECTION code_clib

    PUBLIC  fdtell
    PUBLIC  _fdtell

    INCLUDE "target/agon/def/mos_api.inc"

;long fdtell(int fd)
fdtell:
_fdtell:
    pop     hl
    pop     bc                          ;fd
    push    bc
    push    hl
    MOSCALL (mos_getfil)                ;exits with hlu = file structure
    push    .lhl
    pop     .lix
    ld      .lhl, (ix+fil_fptr)
    ld      .lde, (ix+fil_fptr+2)
    ret
