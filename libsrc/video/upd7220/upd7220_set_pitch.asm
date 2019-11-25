

    SECTION     code_clib
    PUBLIC      __upd7220_set_pitch

    INCLUDE     "video/upd7220/upd7220.inc"

; Entry: l = pitch
__upd7220_set_pitch:
    ld      a,UPD7220_COMMAND_PITCH
    out     (UPD_7220_COMMAND_WRITE),a
    ld      a,l
    out     (UPD_7220_PARAMETER_WRITE),a
    ret

