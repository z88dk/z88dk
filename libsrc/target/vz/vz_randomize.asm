;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Re-seeds the Randomizer - use before getrnd()
;*****************************************************

; ----- int vz_randomize()

    SECTION code_clib
    PUBLIC  vz_randomize
    PUBLIC  _vz_randomize

vz_randomize:
_vz_randomize:

    call $01d3
    ret