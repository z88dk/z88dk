

; long lseek(int fd, long posn, int whence)
; whence = 0 = start
; whence = 1 = from current
; whence = 2 = from end


SECTION code_clib

PUBLIC lseek
PUBLIC _lseek
PUBLIC ___lseek

EXTERN l_long_add

INCLUDE "target/agon/def/mos_api.inc"

lseek:
_lseek:
___lseek:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      de,(ix+4)
    ld      hl,(ix+2)
    ld      bc,(ix+6)
    ld      a,(ix+0)
    and     a
    jr      z,doseek
    push    de
    push    hl
    push    bc
    dec     a
    jr      nz,seek_from_end
; Seek from current position
    MOSCALL(mos_getfil)  ;exits with hlu = file structure
    push.l  hl
    pop.l   ix
    ld.l    hl,(ix+fil_fptr)
    ld.l    de,(ix+fil_fptr+2)
    call    l_long_add
    pop     bc
    jr      doseek

; Seek from end
seek_from_end:
    MOSCALL(mos_getfil)  ;exits with hlu = file structure
    push.l  hl
    pop.l   ix
    ld.l    hl,(ix+ffobjid_objsize)
    ld.l    de,(ix+ffobjid_objsize+2)
    call    l_long_add
    pop     bc

; c = file handle
; dehl = position
doseek:
    MOSCALL(mos_flseek)  ;exits with a = flag
    ld      de,-1
    ld      hl,-1
    and     a
    jr      nz,get_position
    pop     ix
    ret                 ;fail to seek
get_position:
    MOSCALL(mos_getfil)  ;exits with hlu = file structure
    push.l  hl
    pop.l   ix
    ld.l    hl,(ix+fil_fptr)
    ld.l    de,(ix+fil_fptr+2)
    pop     ix
    ret



