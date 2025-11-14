    MODULE  snprintf
    SECTION code_clib

    PUBLIC  snprintff

    EXTERN  asm_printf
    EXTERN  sprintff_outc
    EXTERN  __sgoioblk




; sccz80 version
;void snprintf(char *__far buf, size_t,char *fmt,...)
;{
;void vsprintf(char *buf, char *fmt,va_list ap)
;
;        num=vfprintf(temp,(unsigned char *)(*(ct-1)),ct-2);
;
;        printf1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
snprintff:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,sp   ;points to buf MSW
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix      ;save callers
ENDIF
    ld      a,(hl)      ;buf
    dec     hl
    ld      b,(hl)
    dec     hl
    ld      c,(hl)
    dec     hl          ;&fmt+1
    ld      d,(hl)
    dec     hl
    ld      e,(hl)
    dec     hl      ;&fmt+1
    push    de
    ld      e,a         ;MSW of __far
    ld      d,0
    push    de
    push    bc          ;LSW of __far
    ex      de,hl   ;de=&fmt
    ld      hl,0
    add     hl,sp
    push    hl      ;fp
    ld      bc,sprintff_outc
    push    bc
    ld      bc,1    ;sccz80
    push    bc
    ex      de,hl   ;hl=&fmt+1
    ld      b,(hl)  ;fmt
    dec     hl
    ld      c,(hl)
    push    bc
    dec     hl
    dec     hl
    push    hl      ;&ap
    call    asm_printf
    ex      de,hl
    ld      hl,10+6
    add     hl,sp
    ld      sp,hl
    ex      de,hl
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix
ENDIF
    ret


