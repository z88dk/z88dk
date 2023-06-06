SECTION code_clib

PUBLIC undrawto_callee
PUBLIC _undrawto_callee
PUBLIC undrawto
PUBLIC _undrawto


EXTERN __agon_drawto
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_bgcol


; extern void __LIB__ drawto(int x2, int y2) __smallc;
undrawto:
_undrawto:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_drawto
    pop     ix
    ret

; extern void __LIB__ draw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
undrawto_callee:
_undrawto_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_drawto
    pop     ix
    pop     bc
    pop     af
    pop     af
    push    bc
    ret
