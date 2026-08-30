
    MODULE _vfprintf
    SECTION    code_clib

    PUBLIC    _vfprintf

    EXTERN    asm_printf
    EXTERN    fputc_callee
    EXTERN    __sgoioblk




; sdcc version
;void vfprintf(FILE *fp, char *fmt,va_list ap)
_vfprintf:
    ; A return address can't go through AF on these CPUs: the flags byte does not
    ; read back what was pushed, and on the VM1 pop af also switches the data bank.
    IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      hl,4
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)          ;fmt
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)          ;ap
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a             ;fp
    ELSE
    pop     af
    pop     hl    ;fp
    pop     de    ;fmt
    pop     bc    ;ap
    push    bc
    push    de
    push    hl
    push    af
    ENDIF
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix
ENDIF
    push    hl    ;fp
    ld      hl,fputc_callee
    push    hl
    ld      hl,0
    push    hl
    push    de
    push    bc
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


