
    MODULE  printk
    SECTION code_clib

    PUBLIC  printk
    PUBLIC  cprintf

    EXTERN  asm_printf
    EXTERN  printk_outc




; sccz80 version
;void printk(char *fmt,...)
;{
;        int  *ct;
;        ct= (getarg()*2)+&fmt-4;
;
;        printk1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
printk:
cprintf:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,sp        ;&fmt
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix
ENDIF
    push    bc        ;fp (we don't care about the fp)
    ld      bc,printk_outc
    push    bc
    ld      bc,1
    push    bc
    ld      e,(hl)
    inc     hl
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

