
    PUBLIC  __clib_exit_stack_size
    EXTERN  __exit_atexit_funcs

IF __clib_exit_stack_size > 0
    ld      hl, -(__clib_exit_stack_size * 2)
    add     hl,sp
    ld      sp,hl
  IF __CPU_GBZ80__
    ld      hl,sp+0
    ld      d,h
    ld      e,l
    ld      hl,__exit_atexit_funcs
    ld      a,e
    ld      (hl+),a
    ld      a,d
    ld      (hl+),a
  ELSE
    ld      (__exit_atexit_funcs),hl
  ENDIF
ENDIF


