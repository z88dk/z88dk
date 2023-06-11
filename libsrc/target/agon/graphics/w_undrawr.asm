SECTION code_clib

PUBLIC undrawr_callee
PUBLIC _undrawr_callee
PUBLIC undrawr
PUBLIC _undrawr


EXTERN __agon_drawr
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_bgcol


; extern void __LIB__ drawr(int x_delta, int y_delta) __smallc;
undrawr:
_undrawr:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_drawr
    pop     ix
    ret

; extern void __LIB__ draw_callee(int x_delta, int y_delta) __smallc __z88dk_callee;
undrawr_callee:
_undrawr_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_drawr
    pop     ix
    pop     bc
    pop     af
    pop     af
    push    bc
    ret
