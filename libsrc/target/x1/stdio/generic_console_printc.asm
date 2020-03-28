        SECTION     code_clib

        PUBLIC      generic_console_printc

        EXTERN      generic_console_xypos
        EXTERN      __x1_attr
        EXTERN      __x1_pcg_mode
        EXTERN      CRT_FONT
        EXTERN      asm_load_charset


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    call    generic_console_xypos
    ld      c,l
    ld      b,h
    ld      hl,__x1_pcg_mode
    out     (c),a
    res     4,b
    cp      128
    ld      a,(__x1_attr)
    jr      nc,is_udg
    bit     0,(hl)
    jr      z,do_print
set_pcg_flag:
    set     5,a
do_print: 
    out     (c),a
    ret
is_udg:
    bit     1,(hl)
    jr      z,do_print
    jr      set_pcg_flag


    SECTION code_crt_init

    ld      hl,CRT_FONT
    ld      a,h
    or      l
    jr      z,no_custom_font
    ld      b,96
    ld      c,32
    call    asm_load_charset
    ld      a,1
    ld      (__x1_pcg_mode),a
no_custom_font:

