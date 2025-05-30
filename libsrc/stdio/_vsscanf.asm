
    MODULE _vsscanf
    SECTION    code_clib

    PUBLIC    _vsscanf

        EXTERN  asm_scanf




; sdcc version
;void vsscanf(char *buf, char *fmt,va_list ap)
_vsscanf:
    ld      hl,2
    add     hl,sp    ;hl = &buf

IF !__CPU_INTEL__
    push    ix    ;save callers
ENDIF
    ld      bc,65535        ;infinite length
    push    bc
    ld      bc,2+128      ;h=ungetc, l=_IOREAD|_IOSTRING
    push    bc
    ld      c,(hl)        ;get buf
    inc     hl
    ld      b,(hl)
    inc     hl
    push    bc
    ex      de,hl        ;de=&fmt
    ld      hl,0
    add     hl,sp        ;&fp
    push    hl
    ld      hl,0    ;sdcc mode
    push    hl
    ex      de,hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    push    bc    ;fmt
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    push    bc    ;ap
    call    asm_scanf
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    pop     bc
IF !__CPU_INTEL__
    pop     ix
ENDIF
    ret


