
    SECTION code_clib

    PUBLIC  fputc_cons_native
    PUBLIC  _fputc_cons_native


.fputc_cons_native
._fputc_cons_native
    ld de,sp+2
    ld a,(de)
    jp $0008    ; output a character in A
