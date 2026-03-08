;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Enable interrupts
;*****************************************************

; ----- int vz_enableirq()

    SECTION code_clib
    PUBLIC  vz_enableirq
    PUBLIC  _vz_enableirq

vz_enableirq:
_vz_enableirq:

    ei
    ret