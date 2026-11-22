;
; Shared variables between the VT100 and VT52 engines


    MODULE  conio_vars
    SECTION data_clib

    PUBLIC  __aquarius_attr
    PUBLIC  __aquarius_inverse
    PUBLIC  __aquarius_mode
    PUBLIC  __aquarius_video_base

    EXTERN  CLIB_VIDEO_PAGE_PORT

.__aquarius_attr       defb $70	; White on Black
.__aquarius_inverse    defb 7
.__aquarius_mode       defb 1   ; Text mode
.__aquarius_video_base defw 0   ; Base address respecting banking for AQ+ video


    SECTION code_crt_init

    ; Set the base address for the video page
    ld      a,CLIB_VIDEO_PAGE_PORT
    rrca
    rrca
    and     @11000000
    ld      (__aquarius_video_base+1),a

