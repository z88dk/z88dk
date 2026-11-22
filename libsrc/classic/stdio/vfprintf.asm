

; int vfprintf(FILE *fp, unsigned char *fmt,void *ap)
    MODULE  vfprintf
    SECTION code_clib
    PUBLIC  vfprintf

    EXTERN  fputc_callee
    EXTERN  asm_printf

; Cores have signature (in __smallc)
; int vfprintf1(FILE *fp, void (*output_fn)(FILE *fp,int c), int sccz80, unsigned char *fmt,void *ap)


; sccz80
vfprintf:
    ; A return address can't go through AF on these CPUs: the flags byte does not
    ; read back what was pushed, and on the VM1 pop af also switches the data bank.
    IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      hl,4
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)          ; fmt
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)          ; fp
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a             ; ap
    ELSE
    pop     af
    pop     hl      ; ap
    pop     de      ; fmt
    pop     bc      ; fp
    push    bc
    push    de
    push    hl
    push    af
    ENDIF
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix
ENDIF
    push    bc      ;fp
    ld      bc,fputc_callee        ;output_fn
    push    bc
    ld      bc,1    ;sccz80
    push    bc
    push    de      ;fmt
    push    hl      ;ap
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
