    MODULE  fp1100_allram_w_xorpixl
    SECTION code_clib
    PUBLIC  w_xorpixel
    EXTERN  fp1100_pixel_addr
    EXTERN  fp1100_pixel_send
    EXTERN  __fp1100_attr

; hl = x, de = y
w_xorpixel:
    call    fp1100_pixel_addr
    ret     nc
    ld      a, (__fp1100_attr)
    and     7                           ; the ink, flipped
    or      8
    ld      b, a
    jp      fp1100_pixel_send
