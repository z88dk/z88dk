
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_debug_push_frame
EXTERN __debug_framepointer

l_debug_push_frame:
    pop     bc      ;return address
    push    hl      ;entered hl
    ld      hl,(__debug_framepointer)
    ex      (sp),hl ;hl = entry value
    push    hl
    ld      hl,2
    add     hl,sp
    ld      (__debug_framepointer),hl
    pop     hl
    push    bc
    ret
