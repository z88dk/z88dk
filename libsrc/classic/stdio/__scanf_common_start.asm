
    MODULE  __scanf_common_start
    SECTION	code_clib
    PUBLIC  __scanf_common_start

    EXTERN  __scanf_consume_whitespace
    EXTERN  __scanf_nextarg
    EXTERN  __scanf_getchar
    EXTERN  __scanf_ungetchar
    EXTERN  __scanf_check_suppressed
    EXTERN  __scanf_set_signflag


; Common start code for number formats
__scanf_common_start:
IF __CPU_INTEL__
    call    __scanf_check_suppressed
ELSE
    bit     3,(ix-3)        ; suppressing assignment
ENDIF
    call    z,__scanf_nextarg
    call    __scanf_consume_whitespace
    ret     c
    call    consume_sign
    ret     c
    jp      __scanf_getchar

consume_sign:
    call    __scanf_getchar
    ret     c
    cp      '-'
    jr      nz,notneg
IF __CPU_INTEL__
    call    __scanf_set_signflag
ELSE
    set     0,(ix-3)        ; set sign flag
ENDIF
    ret
notneg:
    cp      '+'
    ret     z
    jp      __scanf_ungetchar
