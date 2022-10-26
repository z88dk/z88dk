; void __CALLEE__ *l_bsearch_callee(void *key, void *base, unsigned int n, void *cmp)
; 01.2007 aralbrec

SECTION code_clib
PUBLIC l_bsearch_callee
PUBLIC _l_bsearch_callee
PUBLIC asm_l_bsearch

EXTERN Lbsearch, l_jpiy, l_setix, l_setiy

.l_bsearch_callee
._l_bsearch_callee

    pop af
    pop hl

    call l_setiy


    pop hl
    pop de
    pop bc
    push af

.asm_l_bsearch

    push hl
    ld hl,compare

    call l_setix

    pop hl
    jp Lbsearch

.compare

    push de
    push bc
    push hl

    call l_jpiy

    ld a,l
    pop hl
    pop bc
    pop de
    ret

