;
; Plotting in Timex Hires and mode 0
;

    SECTION code_graphics
    PUBLIC  inc_x_MODE6

IF    FORts2068|FORzxn
    EXTERN  __zx_screenmode
ENDIF
    EXTERN  __zx_console_attr


inc_x_MODE6:

IF    FORts2068|FORzxn
    ld      a, (__zx_screenmode)
;    and     a
	and     7
    jr      z,_mode0

    bit     5, d
    jr      nz, first
    set     5, d
    or      a
    ret
first:
    res     5, d
    inc     e
    jr      _mode6
ENDIF

_mode0:
    ; We are on a standard zx screen
    push    de
;;  IF    FORts2068|FORzxn
;;    ld      a, d
;;    and     @00100000
;;    ld      c, a                        ;Save page flag   (BC should be preserved!!)
;;  ENDIF
    ld      a, d
    rrca
    rrca
    rrca
    and     3
    or      88
;;  IF    FORts2068|FORzxn
;;    or      c                           ;Add in screen 1 bit
;;  ENDIF
    ld      d, a
    ld      a, (__zx_console_attr)
    ld      (de), a
    ; And increment the column
    pop     de
    inc     de

_mode6:
    ld      a, e
    and     $1f
    ret     nz
    scf

    ret
