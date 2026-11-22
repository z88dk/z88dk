
SECTION code_clib

PUBLIC cls_BITMAP

EXTERN  __aquarius_video_pagein
EXTERN  __aquarius_video_pageout

EXTERN  __aquarius_video_base
EXTERN  __aquarius_attr

cls_BITMAP:
    call    __aquarius_video_pagein
    ld      hl,(__aquarius_video_base)
    ld      de,hl
    inc     de
    ld      bc,+(40 * 25 * 8) - 1
    ld      (hl),0x00
    ldir
    ld      hl,(__aquarius_video_base)
    ld      bc,$2000
    add     hl,bc
    ld      de,hl
    inc     de
    ld      bc,+(40 * 25) - 1
    ld      a,(__aquarius_attr)
    ld      (hl),a
    ldir
    call    __aquarius_video_pageout
    ret


