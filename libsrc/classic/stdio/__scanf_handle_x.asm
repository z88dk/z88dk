    MODULE  __scanf_handle_x
    SECTION code_clib
    PUBLIC  __scanf_handle_x
    PUBLIC  __scanf_handle_p
    PUBLIC  __scanf_x_only_0_on_stream
    PUBLIC  __scanf_x_fmt_leader_found

    EXTERN  __scanf_common_start
    EXTERN  __scanf_getchar
    EXTERN  __scanf_ungetchar
    EXTERN  scanf_exit
    EXTERN  scanf_loop
    EXTERN  asm_isxdigit
    EXTERN  asm_toupper
    EXTERN  __scanf_parse_number

    EXTERN  __scanf_check_suppressed
    EXTERN  __scanf_increment_conversions
    EXTERN  __scanf_check_long

__scanf_handle_x:
__scanf_handle_p:
    call    __scanf_common_start    ;de=argument as necessary
    jp      c,scanf_exit
    cp      '0'
    jr      nz,handle_x_fmt_nobase
    call    __scanf_getchar
    jr      c,__scanf_x_only_0_on_stream    ;there's only a 0 on the stream
    call    asm_toupper
    cp      'X'
    jr      z,__scanf_x_fmt_leader_found
    call    asm_toupper
    call    asm_isxdigit            ;is it a hex digit?
    ld      b,16                    ;radix
    jp      nc,__scanf_parse_number         ;So parse it in - we can ignore the leading
                                    ;0 since it doesn't change the value
__scanf_x_only_0_on_stream:
    ; There's only a zero on the stream, but we've read two characters from
    ; it and we can't push back two, so fudge it a little
IF __CPU_INTEL__
    call    __scanf_check_suppressed
ELSE
    bit     3,(ix-3)
ENDIF
    jp      nz,scanf_loop                   ;carry on
IF __CPU_INTEL__
    call    __scanf_increment_conversions
ELSE
    inc     (ix-1)                  ;number of converted arguments
ENDIF
    xor     a
    ld      (de),a
    inc     de
    ld      (de),a
IF __CPU_INTEL__
    call    __scanf_check_long
ELSE
    bit     1,(ix-3)
ENDIF
    jp      z,scanf_loop
    inc     de
    ld      (de),a
    inc     de
    ld      (de),a
    jp      scanf_loop

__scanf_x_fmt_leader_found:
    call    __scanf_getchar
    jp      c,scanf_exit
handle_x_fmt_nobase:
    call    asm_toupper
    call    asm_isxdigit
    jp      c,scanf_exit            ;it wasn't a hex digit
    ld      b,16
    jp      __scanf_parse_number
