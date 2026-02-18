;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Disable interrupts
;*****************************************************

; ----- int vz_disableirq()

    SECTION code_clib
    PUBLIC  vz_disableirq
    PUBLIC  _vz_disableirq

vz_disableirq:
_vz_disableirq:

    di
    ret