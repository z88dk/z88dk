;
; Plotting in Timex Hires
;

    SECTION code_graphics
    PUBLIC  inc_y_MODE6


inc_y_MODE6:

    inc     d
    ld      a, d
    and     $07
    ret     nz

    ld      a, d
    sub     $08
    ld      d, a
    ld      a, e
    add     a, $20
    ld      e, a
    ret     nc

    ld      a, d
    add     a, $08
    ld      d, a

    and     95
    cp      $58
    ccf

    ret
