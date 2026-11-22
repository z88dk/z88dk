; TRS80 Model 2 CP/M initialisation code
;
; Turn off the mc6845 cursor

SECTION code_clib

PUBLIC cpm_platform_init
EXTERN asm_set_cursor_state


cpm_platform_init:
    ld      l,0x20
    call    asm_set_cursor_state
    ret
