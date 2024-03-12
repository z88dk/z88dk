
; Unwind the atexit() stack

    PUBLIC  __clib_exit_stack_size

    ld      hl,(__exit_atexit_funcs)
IF __clib_exit_stack_size > 0
    ld      de, +(__clib_exit_stack_size * 2)
    add     hl,de
    ld      sp,hl
ENDIF

