
SECTION code_driver

PUBLIC  fgetc_cons_basic


.fgetc_cons_basic
    rst $10      ; input a character in A
    ld l,a
    ld h,0
    ret
