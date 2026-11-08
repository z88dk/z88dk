    MODULE  fp1100_allram_w_pointxy
    SECTION code_clib
    PUBLIC  w_pointxy
    EXTERN  fp1100_pixel_addr
    EXTERN  fp1100_sub_send
    EXTERN  fp1100_sub_read
    EXTERN  __fp1100_attr

    INCLUDE "../sub/sub.inc"

; hl = x, de = y.  NZ if the pixel is not the paper colour (the planes are read back by the sub program), Z if it is or is off the screen.
w_pointxy:
    call    fp1100_pixel_addr
    jr      c, pt_on
    xor     a
    ret
pt_on:
    ld      a, SUB_POINT
    call    fp1100_sub_send
    ld      a, l
    call    fp1100_sub_send
    ld      a, h
    call    fp1100_sub_send
    ld      a, c
    call    fp1100_sub_send
    call    fp1100_sub_read
    ld      b, a
    ld      a, (__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    and     7
    xor     b                           ; 0 if it is the paper
    ret
