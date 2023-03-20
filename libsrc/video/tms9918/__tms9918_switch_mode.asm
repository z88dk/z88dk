

SECTION code_clib

PUBLIC  __tms9918_switch_mode


EXTERN  __tms9918_screen_mode
EXTERN  VDPreg_Write

; Entry: a = screen mode
;        l = register 0 value
;        h = register 1 value
__tms9918_switch_mode:
    ld      (__tms9918_screen_mode),a
    ld      e,0             ;Start from register 0
IF FORm5
    set     0,l             ;EXT Video has to always be on
ENDIF
    ld      a,l
    call    VDPreg_Write
    ld      a,h
IF FORadam
    res     5,a             ;No interrupts on an adam for CP/M breaks
ENDIF
    call    VDPreg_Write
    ret