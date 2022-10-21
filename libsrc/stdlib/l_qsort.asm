; CALLER linkage for function pointers

SECTION code_clib
PUBLIC l_qsort
PUBLIC _l_qsort
EXTERN asm_l_qsort
EXTERN l_setiy

.l_qsort
._l_qsort

    pop de
    pop hl

    call l_setiy

    pop hl
    pop bc
    push bc
    push hl
    push hl
    push de
   
    jp asm_l_qsort
