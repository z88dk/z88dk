
    MODULE printf
    SECTION    code_clib

    PUBLIC    printf

    EXTERN    asm_printf
    EXTERN    printf_outc
    EXTERN    __sgoioblk
    EXTERN    fputc_callee




; sccz80 version
;void printf(char *fmt,...)
;{
;        int  *ct;
;        ct= (getarg()*2)+&fmt-4;
;
;        printf1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
printf:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,sp
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix        ;save callers
ENDIF
    ld      bc,__sgoioblk+10
    push    bc
    ld      bc,fputc_callee        ;printf_outc
    push    bc
    ld      bc,1
    push    bc
    ld      e,(hl)
    inc      hl
    ld      d,(hl)    
    push    de
    dec     hl
    dec     hl
    dec     hl
    push    hl
    call    asm_printf
    pop     bc
    pop     bc    
    pop     bc    
    pop     bc
    pop     bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix
ENDIF
    ret


