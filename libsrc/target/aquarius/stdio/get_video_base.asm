

SECTION code_clib

PUBLIC  __aquarius_video_pagein
PUBLIC  __aquarius_video_pageout
PUBLIC  __aquarius_pcg_pagein
EXTERN  CLIB_VIDEO_PAGE_PORT

; Page in the video RAM for bitmap mode
__aquarius_video_pagein:
    pop     hl
    in      a,(CLIB_VIDEO_PAGE_PORT)
    push    af
    ld      a,20
    out     (CLIB_VIDEO_PAGE_PORT),a
    push    hl
    ret

; Page in the PCG page for setting the font for text mode
__aquarius_pcg_pagein:
    pop     hl
    in      a,(CLIB_VIDEO_PAGE_PORT)
    push    af
    ld      a,21
    out     (CLIB_VIDEO_PAGE_PORT),a
    push    hl
    ret

; Restore paging
__aquarius_video_pageout:
    pop     hl
    pop     af
    out     (CLIB_VIDEO_PAGE_PORT),a
    push    hl
    ret


