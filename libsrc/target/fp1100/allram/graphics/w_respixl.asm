    MODULE  fp1100_allram_w_respixl
    SECTION code_clib
    PUBLIC  w_respixel
    EXTERN  fp1100_pixel_addr
    EXTERN  fp1100_pixel_send
    EXTERN  __fp1100_attr

; hl = x, de = y
w_respixel:
    call    fp1100_pixel_addr
    ret     nc
    ld      a, (__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    and     7                           ; the paper
    ld      b, a
    jp      fp1100_pixel_send
