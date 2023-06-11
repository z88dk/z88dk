
SECTION code_driver

PUBLIC  fputc_cons_basic


.fputc_cons_basic
    ld de,sp+2
    ld a,(de)
    jp $0008    ; output a character in A
