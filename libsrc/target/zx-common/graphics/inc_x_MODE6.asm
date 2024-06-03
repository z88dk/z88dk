;
; Plotting in Timex Hires
;

    SECTION code_graphics
    PUBLIC  inc_x_MODE6


inc_x_MODE6:

    bit     5, d
    jr      nz, first
    set     5, d
    or      a
    ret
first:
    res     5, d
    inc     e
    ld      a, e
    and     $1f
    ret     nz
    scf

    ret
