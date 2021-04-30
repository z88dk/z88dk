

    MODULE  __zx_printc_attr
    SECTION code_driver
    PUBLIC  __zx_printc_attr

    EXTERN  __zx_screenmode
    EXTERN  __zx_console_attr
IF FORsam
    EXTERN  SCREEN_BASE
    EXTERN  __sam_graphics_pageout
ENDIF


; Set the attributes for the character that has just been printed
;
; Entry: de = screen address
__zx_printc_attr:
IF FORts2068|FORzxn
    ld      a,d
    and     @0100000
    ld      l,a
    ld      a,(__zx_screenmode)
    cp      6
    ret     z
    cp      2
    jr      nz,not_hi_colour
    set     5,d
    ld      a,(__zx_console_attr)
    ld      b,8
hires_set_attr:
    ld      (de),a
    dec     d
    djnz    hires_set_attr
    ret
not_hi_colour:
ENDIF
    ld      a,d
    rrca
    rrca
    rrca
    and     3
IF FORsam
    or      +(SCREEN_BASE / 256) + 24 
ELSE
    or      88
ENDIF
IF FORts2068|zxn
    or      l        ;Add in screen 1 bit
ENDIF
    ld      d,a
    ld      a,(__zx_console_attr)
    ld      (de),a
IF FORsam
    call    __sam_graphics_pageout
ENDIF
    ret
