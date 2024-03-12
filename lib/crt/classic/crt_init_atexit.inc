
    PUBLIC  __clib_exit_stack_size
    EXTERN  __exit_atexit_funcs

IF __clib_exit_stack_size > 0
    ld      hl, -(__clib_exit_stack_size * 2)
    add     hl,sp
    ld      sp,hl
ENDIF
IF __CPU_GBZ80__
    ld      hl,sp+0
    ld      d,h
    ld      e,l
    ld      hl,__exit_atexit_funcs
    ld      a,l
    ld      (hl+),a
    ld      a,h
    ld      (hl+),a
ELIF __CPU_INTEL__
    ld      hl,0
    add     hl,sp
    ld      (__exit_atexit_funcs),hl
ELSE
    ld      (__exit_atexit_funcs),sp
ENDIF

