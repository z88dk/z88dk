SECTION code_clib

PUBLIC drawto_callee
PUBLIC _drawto_callee
PUBLIC drawto
PUBLIC _drawto


EXTERN __agon_drawto
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_fgcol


; extern void __LIB__ drawto(int x2, int y2) __smallc;
drawto:
_drawto:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_drawto
    pop     ix
    ret

; extern void __LIB__ draw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
drawto_callee:
_drawto_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_drawto
    pop     ix
    pop     bc
    pop     af
    pop     af
    push    bc
    ret
