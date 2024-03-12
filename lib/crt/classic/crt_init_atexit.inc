
    PUBLIC  __clib_exit_stack_size
    EXTERN  exitsp

IF __clib_exit_stack_size > 0
    ld      hl, -(__clib_exit_stack_size * 2)
    add     hl,sp
    ld      sp,hl
ENDIF
IF __CPU_GBZ80__
    ld      hl,sp+0
    ld      d,h
    ld      e,l
    ld      hl,exitsp
    ld      a,l
    ld      (hl+),a
    ld      a,h
    ld      (hl+),a
ELIF __CPU_INTEL__
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
ELSE
    ld      (exitsp),sp
ENDIF

