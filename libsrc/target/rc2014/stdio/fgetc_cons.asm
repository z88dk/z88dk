
    SECTION code_clib

    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons


.fgetc_cons
._fgetc_cons
    rst $10      ; input a character in A
    ld l,a
    ld h,0
    ret
