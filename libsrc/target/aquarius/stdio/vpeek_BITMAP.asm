
    SECTION code_clib

    PUBLIC  vpeek_BITMAP
    EXTERN  xypos_BITMAP
    EXTERN  __aquarius_video_pagein
    EXTERN  __aquarius_video_pageout
    EXTERN  vpeek_screendollar


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_BITMAP:
    ld      hl,-8
    add     hl,sp           ;de = screen, hl = buffer, bc = coords
    ld      sp,hl
    push    hl              ;Save buffer
    ex      de,hl           ;get it into de
    call    __aquarius_video_pagein ;uses hl
    call    xypos_BITMAP
    ld      b,8
vpeek_1:
    ld      a,(hl)
    ld      (de),a
    inc     de
    ld      a,l
    add     40
    ld      l,a
    jr      nc,no_overflow
    inc     h
no_overflow:
    djnz    vpeek_1
    call    __aquarius_video_pageout
    jp      vpeek_screendollar

