
; Unwind the atexit() stack

    PUBLIC  __clib_exit_stack_size

    ld      hl,(exitsp)
IF __clib_exit_stack_size > 0
    ld      de, +(__clib_exit_stack_size * 2)
    add     hl,de
    ld      sp,hl
ENDIF

