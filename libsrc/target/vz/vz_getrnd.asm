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

vz_getrnd:
_vz_getrnd:

    ld bc,$0000
    call $09b4    ; Loads ACC with BCDE
    call $0a9d    ; Set flag to Integer
    call $14c9    ; RND routine. Using ACC, not A
    call $0a7f    ; CINT. Puts ACC into HL
    ret