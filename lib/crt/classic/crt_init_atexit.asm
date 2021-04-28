
    PUBLIC  __clib_exit_stack_size

IF __clib_exit_stack_size > 0
    ld      hl, -(__clib_exit_stack_size * 2)
    add     hl,sp
    ld      sp,hl
ENDIF

