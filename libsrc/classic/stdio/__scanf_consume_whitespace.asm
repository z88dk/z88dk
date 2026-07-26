
    MODULE  __scanf_consume_whitespace
    SECTION code_clib
    PUBLIC  __scanf_consume_whitespace

    EXTERN  __scanf_getchar
    EXTERN  __scanf_ungetchar
    EXTERN  asm_isspace


__scanf_consume_whitespace:
    call    __scanf_getchar
    ret     c
    call    asm_isspace
    jr      nc,__scanf_consume_whitespace
    call    __scanf_ungetchar         ;push back the non-matching character
    and     a
    ret
