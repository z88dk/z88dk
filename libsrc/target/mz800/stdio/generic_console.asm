; Sharp MZ-800 console: clear the whole screen to the paper pen, and the start-up code (the graphics screen, cleared).  The start-up code is in the same module as
; generic_console_cls, which the console always references: a library module is linked only if something refers to it, and this one has nothing else to be found by.
    SECTION code_clib
    PUBLIC  generic_console_cls
    EXTERN  __mz800_gfx_clear
    EXTERN  __mz800_con_paper

generic_console_cls:
    ld      a, (__mz800_con_paper)
    jp      __mz800_gfx_clear

    SECTION code_crt_init
    EXTERN  mz800_gfx_init
    call    mz800_gfx_init
    call    generic_console_cls
