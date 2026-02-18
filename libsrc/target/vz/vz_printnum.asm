;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Prints a number -32767 to 32768 to mode(0)
;*****************************************************

; ----- void __FASTCALL__ vz_printnum(int n)

    SECTION code_clib
    PUBLIC  vz_printnum
    PUBLIC  _vz_printnum
    EXTERN  vz_printnum

vz_printnum:
_vz_printnum:

    ex de,hl
    ld bc,$0000
    call $09b4      ; Loads ACC with BCDE
    call $0a9d      ; Set flag to Integer    
    call $0fbd      ; Convert ACC to ASCII string 0-delim HL points to string  
    xor a
    ld ($409c),a    ; Set output to 0 = video display
    call $28a7      ; Print number on screen
    ld a,$0d
    call $033a      ; Print a <CR>
    ret