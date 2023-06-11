    MODULE  __scanf_handle_s
    SECTION code_clib
    PUBLIC  __scanf_handle_s

    EXTERN  __scanf_common_start
    EXTERN  __scanf_nextarg
    EXTERN  __scanf_consume_whitespace
    EXTERN  scanf_exit
    EXTERN  __scanf_ungetchar
    EXTERN  __scanf_getchar
    EXTERN  scanf_loop

    EXTERN  __scanf_check_suppressed
    EXTERN  __scanf_check_width
    EXTERN  __scanf_increment_conversions
    EXTERN  __scanf_get_width

    EXTERN  asm_isspace

__scanf_handle_s:
IF __CPU_INTEL__
    call    __scanf_check_suppressed
ELSE
    bit     3,(ix-3)
ENDIF
    call    z,__scanf_nextarg               ;de=destination
IF __CPU_INTEL__
    ld      b,0
    call    __scanf_get_width
ELSE
    ld      b,(ix-4)                ;b=width
ENDIF
scanf_fmt_s_width_specified:
    call    __scanf_consume_whitespace
    jp      c,scanf_exit
    call    __scanf_getchar
    jr      nc,scanf_fmt_s_join
    jp      scanf_exit
scanf_fmt_s_loop:
    call    __scanf_getchar
    jr      c,scanf_fmt_s_done
    call    asm_isspace
    jr      nc,scanf_fmt_s_success
scanf_fmt_s_join:
IF __CPU_INTEL__
    ld      c,a
    call    __scanf_check_suppressed
    ld      a,c
ELSE
    bit     3,(ix-3)        ;we're not setting
ENDIF
    jr      nz,scanf_fmt_s_suppress
    ld      (de),a
    inc     de
scanf_fmt_s_suppress:
IF __CPU_INTEL__
    call    __scanf_check_width
ELSE
    bit     2,(ix-3)        ;if no width specifier just loop
ENDIF
    jr      z,scanf_fmt_s_loop
    djnz    scanf_fmt_s_loop
scanf_fmt_s_done:
IF __CPU_INTEL__
    call    __scanf_check_suppressed
    ld      a,0
ELSE
    xor     a
    bit     3,(ix-3)        ;suppress setting
ENDIF
    jp      nz,scanf_loop
    ld      (de),a          ;terminating \0
IF __CPU_INTEL__
    call    __scanf_increment_conversions
ELSE
    inc     (ix-1)          ;increase number of conversions done
ENDIF
    jp      scanf_loop
scanf_fmt_s_success:
    call    __scanf_ungetchar
    jr      scanf_fmt_s_done
