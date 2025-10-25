
    MODULE  __scanf_handle_n
    SECTION code_clib
    PUBLIC  __scanf_handle_n

    EXTERN  __scanf_nextarg
    EXTERN  scanf_loop

    EXTERN  __scanf_check_suppressed
    EXTERN  __scanf_check_long
    EXTERN  __scanf_context



__scanf_handle_n:
IF __CPU_INTEL__
    call    __scanf_check_suppressed
ELSE
    bit     3,(ix-3)                ;suppressed?
ENDIF
    jp      nz,scanf_loop
    call    __scanf_nextarg
IF __CPU_INTEL__
    push    hl
    ld      hl,(__scanf_context)
    ld      bc,-6
    add     hl,bc
    ld      a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(hl)
    ld      (de),a
    pop     hl
ELSE
    ld      a,(ix-6)
    ld      (de),a
    inc     de
    ld      a,(ix-5)
    ld      (de),a
ENDIF
IF __CPU_INTEL__
    call    __scanf_check_long
ELSE
    bit     1,(ix-3)
ENDIF
    jr      z,scanf_handle_n_exit
    xor     a
    inc     de
    ld      (de),a
    inc     de
    ld      (de),a
scanf_handle_n_exit:
    jp      scanf_loop
