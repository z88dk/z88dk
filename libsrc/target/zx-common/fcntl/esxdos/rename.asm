    
MODULE  esx_rename
SECTION code_esxdos
EXTERN  asm_esxdos_f_rename
PUBLIC  rename
PUBLIC  _rename


; int rename(const char *s, const char *d);
rename:
_rename:
    pop     bc
    pop     de  ;d
    pop     hl  ;s
    push    hl
    push    de
    push    bc
    push    ix
    ld      a,'*'
    call    asm_esxdos_f_rename
    pop     ix
    ret
