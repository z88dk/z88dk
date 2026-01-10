;
; Plotting in Timex Hires
;

    SECTION code_graphics

    PUBLIC  hl_inc_x_MODE6

    EXTERN  __zx_screenmode
    EXTERN  __zx_console_attr

  IF    FORsam|FORz88
    ; This code won't work on the same due to the lack of correct paging
    ; but it is assembled as part of zx-common
    EXTERN  SCREEN_BASE
  ENDIF


hl_inc_x_MODE6:
    ld      a, (__zx_screenmode)
	and     7
  IF    FORts2068|FORzxn
    cp      6
    jr      z,MODE6_no_color            ;No colour in hires
  ENDIF

    cp      2                           ;High colour
    jr      nz, standard_modes
    set     5, h
    ld      a, (__zx_console_attr)
    ld      (hl), a
    res     5, h
    inc     hl
    ret

standard_modes:
    ; We are on a standard zx screen
    push    hl
  IF    FORts2068|FORzxn
    ld      a, h
    and     @00100000
    ld      c, a                        ;Save page flag
  ENDIF
    ld      a, h
    rrca
    rrca
    rrca
    and     3
  IF    FORsam|FORz88
    or      +(SCREEN_BASE/256)+24
  ELSE
    or      88
  ENDIF
  IF    FORts2068|FORzxn
    or      c                           ;Add in screen 1 bit
  ENDIF
    ld      h, a
    ld      a, (__zx_console_attr)
    ld      (hl), a
    ; And increment the column
    pop     hl
    inc     hl

    ret

  IF    FORts2068|FORzxn
MODE6_no_color:
    ld      a, h
    xor     @00100000
    cp      h
    ld      h, a
    ret     nc
    inc     hl
	ret
  ENDIF
