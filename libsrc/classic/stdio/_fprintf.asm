
    MODULE _fprintf
    SECTION    code_clib

    PUBLIC    _fprintf

    EXTERN    asm_printf
    EXTERN    fputc_callee





;sdcc version
_fprintf:
    ; A return address can't go through AF on these CPUs: the flags byte does not
    ; read back what was pushed, and on the VM1 pop af also switches the data bank.
    IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      hl,2
    add     hl,sp
    ld      c,(hl)
    inc     hl
    ld      b,(hl)          ;fp
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)          ;fmt
    inc     hl              ;points to ap
    ELSE
    ld      hl,6
    add     hl,sp    ;points to ap
    pop     af    ;ret address
    pop     bc    ;fp
    pop     de    ;fmt
    push    de
    push    bc
    push    af
    ENDIF
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix    ;save ix
ENDIF
    push    bc    ;fp
    ld      bc,fputc_callee
    push    bc
    ld      bc,0    ;flag
    push    bc
    push    de    ;fmt
    push    hl    ;argument
    call    asm_printf
    pop     bc
    pop     bc
    pop     bc    
    pop     bc
    pop     bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix    ;restore ix
ENDIF
    ret

