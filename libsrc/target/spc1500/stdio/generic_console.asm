; Samsung SPC-1500 console: clear the whole screen to the paper pen (also the
; graphics library's clg), and the start-up code (the screen cleared: the
; graphics mode is the crt0's).  The start-up code is in the same module as
; generic_console_cls, which the console always references: a library module
; is linked only if something refers to it, and this one has nothing else to
; be found by.
    SECTION code_clib
    PUBLIC  generic_console_cls
    EXTERN  __spc1500_gfx_clear
    EXTERN  __spc1500_con_paper

generic_console_cls:
    ld      a, (__spc1500_con_paper)
    jp      __spc1500_gfx_clear

    SECTION code_crt_init
    call    generic_console_cls
