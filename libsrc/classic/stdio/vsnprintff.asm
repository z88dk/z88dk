
    MODULE vsnprintf
    SECTION    code_clib

    PUBLIC    vsnprintff

    EXTERN    asm_printf
    EXTERN    sprintff_outc
    EXTERN    __sgoioblk




; sccz80 version
;void vsprintf(char *__far buf, size_t, char *fmt,va_list ap)
; int vfprintf1(FILE *fp, void __CALLEE__ (*output_fn)(int c,FILE *fp), int sccz80, unsigned char *fmt,void *ap)

vsnprintff:
    ld      hl,8
    add     hl,sp        ;&buf MSW
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix
ENDIF
    ld      a,(hl)      ;buf MSW
    dec     hl
    ld      b,(hl)
    dec     hl
    ld      c,(hl)
    dec     hl          ;&size+1
    ld      d,(hl)
    dec     hl
    ld      e,(hl)
    dec     hl          ;&fmt+1
    push    de
    ld      e,a         ;MSW of __far
    ld      d,0
    push    de
    push    bc          ;LSW of __far
    ex      de,hl       ;de=&fmt+1
    ld      hl,0
    add     hl,sp
    push    hl          ;file
    ld      bc,sprintff_outc
    push    bc
    ld      bc,1        ;sccz80 mode
    push    bc
    ex      de,hl       ;hl=&fmt+1
    ld      d,(hl)
    dec     hl
    ld      e,(hl)
    dec     hl    ;&ap
    push    de    ;fmt
    ld      d,(hl)
    dec     hl
    ld      e,(hl)
    push    de
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


