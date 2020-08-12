    MODULE  __printf_doprint
    SECTION code_clib
    PUBLIC  __printf_doprint

    EXTERN  __printf_increment_chars_written
    EXTERN  __printf_get_fp
    EXTERN  __printf_get_print_function

; Print a character
; Entry: a = character to print
__printf_doprint:
    push    hl              ;save fmt
    push    de              ;save ap
    push    bc
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_increment_chars_written
ELSE
    push    ix
    inc     (ix-2)          ;increment characters written
    jr      nz,no_inc
    inc     (ix-1)
no_inc:
ENDIF
    ld      c,a
    ld      b,0
    push    bc              ;character to print
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_get_fp
ELSE
    ld      c,(ix+10)       ;FP
    ld      b,(ix+11)
ENDIF
    push    bc
    ld      bc,doprint_return       ;where we are going to come back to
    push    bc
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_get_print_function
ELSE
    ld      l,(ix+8)        ;output function (this is callee)
    ld      h,(ix+9)
ENDIF
    jp      (hl)
doprint_return:
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix              ;restore registers
ENDIF
    pop     bc
    pop     de
    pop     hl
    ret

