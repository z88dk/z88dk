IF CLIB_DEFAULT_SCREEN_MODE != -1
    EXTERN  vdp_set_mode
    ld      hl,CLIB_DEFAULT_SCREEN_MODE
    call    vdp_set_mode
ENDIF