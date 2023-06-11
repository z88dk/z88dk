SECTION code_clib

PUBLIC drawr_callee
PUBLIC _drawr_callee
PUBLIC drawr
PUBLIC _drawr


EXTERN __agon_drawr
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_fgcol


; extern void __LIB__ drawr(int x_delta, int y_delta) __smallc;
drawr:
_drawr:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_drawr
    pop     ix
    ret

; extern void __LIB__ draw_callee(int x_delta, int y_delta) __smallc __z88dk_callee;
drawr_callee:
_drawr_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_drawr
    pop     ix
    pop     bc
    pop     af
    pop     af
    push    bc
    ret
