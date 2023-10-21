
SECTION code_clib

PUBLIC  scrollup_BITMAP

EXTERN  __aquarius_attr
EXTERN  __aquarius_video_base
EXTERN  __aquarius_video_pagein
EXTERN  __aquarius_video_pageout

scrollup_BITMAP:
    push    de
    push    bc
    call    __aquarius_video_pagein
    ld      hl,(__aquarius_video_base)
    ld      de,hl
    ld      bc,320
    add     hl,bc
    ld      bc,320 * 24
    ldir
    ex      de,hl
    ld      de,hl
    inc     de
    ld      (hl),0
    ld      bc,320
    ldir
    ld      hl,(__aquarius_video_base)
    set     5,h         ;+8192
    ld      de,hl
    ld      bc,40
    add     hl,bc
    ld      bc,40 * 24
    ldir
    ex      de,hl
    ld      b,40
fillattr:
    ld      a,(__aquarius_attr)
    ld      (hl),a
    inc     hl
    djnz    fillattr
    call    __aquarius_video_pageout
    pop     bc
    pop     de
    ret
