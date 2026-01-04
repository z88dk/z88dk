;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Get a random number 0-65535
;*****************************************************

; ----- int vz_getrnd(int n)

    SECTION code_clib
    PUBLIC  vz_getrnd
    PUBLIC  _vz_getrnd

    ; By default, the n is stored in HL by z88dk
    ; and used in these calls, and the call $0a7f
    ; returns the value in HL which is returned automatically
    ; by z88dk from this function

vz_getrnd:
_vz_getrnd:

    ld bc,$0000
    call $09b4    ; Loads ACC with BCDE
    call $0a9d    ; Set flag to Integer
    call $14c9    ; RND routine. Using ACC, not A
    call $0a7f    ; CINT. Puts ACC into HL
    ret