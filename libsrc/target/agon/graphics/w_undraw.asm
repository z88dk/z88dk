SECTION code_clib

PUBLIC undraw_callee
PUBLIC _undraw_callee
PUBLIC undraw
PUBLIC _undraw


EXTERN __agon_draw
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_bgcol


; extern void __LIB__ undraw(int x1, int y1, int x2, int y2) __smallc;
undraw:
_undraw:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_draw
    pop     ix
    ret

; extern void __LIB__ undraw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
undraw_callee:
_undraw_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_draw
    pop     ix
    pop     bc
    pop     af
    pop     af
    pop     af
    pop     af
    push    bc
    ret
