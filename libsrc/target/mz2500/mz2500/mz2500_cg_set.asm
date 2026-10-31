;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_cg_set(uint8_t reg, uint8_t value) __smallc;
;
;	Write a graphics (CG) register: port $BC selects, port $BD writes.
;

    SECTION code_clib
    PUBLIC  mz2500_cg_set
    PUBLIC  _mz2500_cg_set

mz2500_cg_set:
_mz2500_cg_set:
    pop     hl
    pop     de                          ; value
    pop     bc                          ; register
    push    bc
    push    de
    push    hl
    ld      a,c
    out     ($bc),a
    ld      a,e
    out     ($bd),a
    ret
