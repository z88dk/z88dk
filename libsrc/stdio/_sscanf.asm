    MODULE  sscanf
    SECTION    code_clib

    PUBLIC    _sscanf

    EXTERN    asm_scanf




; sdcc version
;void sscanf(char *buf, char *fmt,...)
;{
;        printf1(fp, ungetc, getc, sccz80_delta, *ct,ct-1);
;}
_sscanf:
    ld      hl,2
    add     hl,sp        ;points to buf
IF !__CPU_INTEL__
    push    ix        ;save callers
ENDIF
    ld      c,(hl)        ;buf
    inc     hl
    ld      b,(hl)
    inc     hl        ;&fmt
    ex      de,hl        ;de=&fmt
    ld      hl,65535        ;infinite length
    push    hl
    ld      hl,2+128    ;h=ungetc, l=_IOREAD|_IOSTRING
    push    hl        ;
    push    bc        ;buf
    ld      hl,0
    add     hl,sp
    push    hl        ;fp
    ld      bc,0        ;sdcc
    push    bc
    ex      de,hl        ;hl=&fmt
    ld      c,(hl)        ;fmt
    inc     hl
    ld      b,(hl)
    inc     hl
    push    bc
    push    hl        ;&ap
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


