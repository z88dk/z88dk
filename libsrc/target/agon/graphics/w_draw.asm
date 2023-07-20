SECTION code_clib

PUBLIC draw_callee
PUBLIC _draw_callee
PUBLIC draw
PUBLIC _draw


EXTERN __agon_draw
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_fgcol


; extern void __LIB__ draw(int x1, int y1, int x2, int y2) __smallc;
draw:
_draw:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_draw
    pop     ix
    ret

; extern void __LIB__ draw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
draw_callee:
_draw_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_draw
    pop     ix
    pop     bc
    pop     af
    pop     af
    pop     af
    pop     af
    push    bc
    ret
