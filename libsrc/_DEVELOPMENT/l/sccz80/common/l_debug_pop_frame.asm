IF !__CPU_GBZ80__

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_debug_pop_frame
EXTERN __debug_framepointer

l_debug_pop_frame:
    pop     bc      ;return code
    ex      (sp),hl ;hl=old frame pointer
    ld      (__debug_framepointer),hl
    pop     hl
    push    bc
    ret

ENDIF
