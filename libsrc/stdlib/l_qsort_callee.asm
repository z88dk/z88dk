; void __CALLEE__ l_qsort_callee(void *base, unsigned int size, void *cmp)
; 01.2007 aralbrec

SECTION code_clib
PUBLIC l_qsort_callee
PUBLIC _l_qsort_callee
PUBLIC asm_l_qsort
EXTERN Lqsort, l_jpiy, l_setix, l_setiy

.l_qsort_callee
._l_qsort_callee

    pop de
    pop hl

    call l_setiy

    pop hl
    pop bc
    push de

.asm_l_qsort

    push hl
    ld hl,compare

    call l_setix


    pop hl
    jp Lqsort

.compare

    push hl
    push de
    push bc

    call l_jpiy

    ld a,l
    pop bc
    pop de
    pop hl
    ret

