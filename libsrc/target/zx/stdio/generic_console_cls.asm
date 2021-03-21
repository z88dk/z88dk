;
; Clear the screen for the ZX/TS2068 terminal
;
    MODULE  generic_console_cls

    SECTION code_driver
    PUBLIC  generic_console_cls

    EXTERN  generic_console_zxn_tile_cls

    EXTERN  __zx_console_attr
    EXTERN  __zx_screenmode


; TODO: Have a separate implementation for SAM, it doesn't need this complexity
IF FORsam
    EXTERN  SCREEN_BASE
ELSE
    defc    SCREEN_BASE = 16384
ENDIF


generic_console_cls:
    push    de
    push    bc
    ld      hl,SCREEN_BASE
    ld      de,SCREEN_BASE+1

IF FORts2068 | FORzxn
    ld      a,(__zx_screenmode)
  IF FORzxn
    bit     6,a
    jp      nz,generic_console_zxn_tile_cls
  ENDIF
    cp      1
    jr      nz,clear_main_screen
    ld      hl,$6000
    ld      de,$6001
clear_main_screen:
ENDIF
    ld      bc,6144
    ld      (hl),l
    ldir
IF FORts2068 | FORzxn
    ld      a,(__zx_screenmode)
    and     a
    jr      z,clear_attributes
    cp      1
    jr      z,clear_attributes
    cp      2
    jr      z,clear_attribute_hicolour
    ; And here we clear the hires screen
    xor    a
clear_screen1:
    ld      hl,$6000
    ld      de,$6001
    ld      bc,6144
    ld      (hl),a
    ldir
    jr      done

clear_attribute_hicolour:
    ld      a,(__zx_console_attr)
    jr      clear_screen1
ENDIF
clear_attributes:
    ld      a,(__zx_console_attr)
    ld      (hl),a
    ld      bc,767
    ldir
done:
    pop    bc
    pop    de
    ret
