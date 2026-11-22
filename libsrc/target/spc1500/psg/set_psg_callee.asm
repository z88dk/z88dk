;
;	Samsung SPC-1500 PSG routines
;
;	int set_psg(int reg, int val);
;

    SECTION code_clib
    PUBLIC  set_psg_callee
    PUBLIC  _set_psg_callee

    PUBLIC  asm_set_psg


set_psg_callee:
_set_psg_callee:

    pop     hl
    pop     de
    ex      (sp), hl

asm_set_psg:
    ld      bc, $1c00
    out     (c), l
    ld      b, $1b
    out     (c), e
    ret
