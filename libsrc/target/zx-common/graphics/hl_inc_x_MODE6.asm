;
; Plotting in Timex Hires
;

    SECTION code_graphics

    PUBLIC  hl_inc_x_MODE6


hl_inc_x_MODE6:

    ld      a, h
    xor     @00100000
    cp      h
    ld      h, a
    ret     nc
    inc     hl

    ret


