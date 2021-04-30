
    MODULE  __zx_gencon_xy_to_dfaddr

    SECTION code_driver
    PUBLIC  __zx_gencon_xy_to_dfaddr

    EXTERN  __zx_screenmode
IF FORsam
    EXTERN  SCREEN_BASE
ENDIF

__zx_gencon_xy_to_dfaddr:
IF FORts2068|FORzxn
    bit     0,c
    push    af
    ld      a,(__zx_screenmode)
    cp      6
    jr      nz,not_hrgmode
    srl     c
not_hrgmode:
ENDIF
    ld      a,b
    rrca
    rrca
    rrca
    and     248
    or      c
    ld      l,a
    ld      a,b
    and     0x18
IF FORsam
    or      SCREEN_BASE / 256
ELSE
    or      0x40
ENDIF
    ld      h,a
IF FORts2068|FORzxn
    ld      a,(__zx_screenmode)
    and     a
    jr      z,dont_use_screen_1
    cp      1               ;screen 1
    jr      z,use_screen_1
    cp      2               ;high colour
    jr      z,dont_use_screen_1
    ; So we're in hires mode
    pop     af
    ret     z               ;Even column no need for it
calc_screen1_offset:
    set     5,h
    ret
use_screen_1:
    pop     af
    jr      calc_screen1_offset
dont_use_screen_1:
    pop     af
ENDIF
    ret


