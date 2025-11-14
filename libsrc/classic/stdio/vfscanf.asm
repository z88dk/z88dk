    MODULE  vfscanf
    SECTION code_clib

    PUBLIC  vfscanf

    EXTERN  asm_scanf
    EXTERN  scanf_ungetc
    EXTERN  scanf_getc




; sccz80 version
;void vfscanf(FILE *fp, char *fp, va_list ap)
;{
;        printf1(fp, ungetc, getc, sccz80_delta, *ct,ct-1);
;}
vfscanf:
    ld      hl,7
    add     hl,sp
    ld      b,(hl)      ;fp
    dec     hl
    ld      c,(hl)
    dec     hl
    ld      d,(hl)      ;fmt
    dec     hl
    ld      e,(hl)
    dec     hl
    ld      a,(hl)
    dec     hl
    ld      l,(hl)
    ld      h,a
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix          ;save callers
ENDIF

    push    bc          ;fp
    ld      bc,1        ;sccz80
    push    bc
    push    de          ;fmt
    push    hl          ;ap
    call    asm_scanf
    pop     bc
    pop     bc
    pop     bc
    pop     bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix
ENDIF
    ret


