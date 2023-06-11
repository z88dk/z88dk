
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_nan_b

EXTERN asm_am9511_derror_einval_zc

.asm_am9511_nan_b

    ; strtod() helper function
    ; return nan(...) given pointer to buffer at '('
    ;
    ; enter : hl = char *buff
    ;
    ; exit  : hl = char *buff (moved past nan argument)
    ;         DEHL'= nan(...)
    ;
    ; uses  : af, hl, bc', de', hl'

    ld a,(hl)

    cp '('
    jp NZ, asm_am9511_derror_einval_zc

    inc hl

loop:
    ld a,(hl)
    or a
    jp Z, asm_am9511_derror_einval_zc

    inc hl
    cp ')'
    jp Z, asm_am9511_derror_einval_zc

    jr loop

