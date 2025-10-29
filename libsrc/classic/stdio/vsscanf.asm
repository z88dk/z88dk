	MODULE  vsscanf
	SECTION	code_clib

	PUBLIC	vsscanf

	EXTERN	asm_scanf
	EXTERN	scanf_ungetc
	EXTERN	scanf_getc
	EXTERN	__sgoioblk




; sccz80 version
;void vsscanf(char *buf, char *fmt,va_arg ap)
;{
;        asm_scanf(fp, ungetc, getc, sccz80_delta, *ct,ct-1);
;}
vsscanf:
    ld      hl,7
    add     hl,sp       ;hl=&buf+1
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix          ;save callers
ENDIF

    ld      b,(hl)      ;buf
    dec     hl
    ld      c,(hl)
    dec     hl          ;&fmt+1
    ex      de,hl           ;de=&fmt+1
    ld      hl,65535    ;infinite length
    push    hl 
    ld      hl,2+128  ;h=ungetc, l=_IOREAD|_IOSTRING
    push    hl
    push    bc          ;buf
    ld      hl,0
    add     hl,sp
    push    hl          ;fp
    ld      bc,1        ;sccz80
    push    bc
    ex      de,hl       ;hl=&fmt+1
    ld      b,(hl)      ;fmt
    dec     hl
    ld      c,(hl)
    push    bc
    dec     hl
    ld      b,(hl)      ;ap
    dec     hl
    ld      c,(hl)
    push    bc
    call    asm_scanf
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    pop     bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix
ENDIF
    ret


