    MODULE  fp1100_allram_w_plotpixl
    SECTION code_clib
    PUBLIC  w_plotpixel
    EXTERN  fp1100_pixel_addr
    EXTERN  fp1100_pixel_send
    EXTERN  __fp1100_attr

; hl = x, de = y
w_plotpixel:
    call    fp1100_pixel_addr
    ret     nc
    ld      a, (__fp1100_attr)
    and     7                           ; the ink
    ld      b, a
    jp      fp1100_pixel_send
