SECTION code_clib

PUBLIC circle_callee
PUBLIC _circle_callee
PUBLIC circle
PUBLIC _circle


EXTERN __agon_circle
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_fgcol


; extern void __LIB__ circle(int x, int y, int radius, int skip) __smallc
circle:
_circle:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_circle
    pop     ix
    ret

; extern void __LIB__ circle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
circle_callee:
_circle_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_fgcol)
    call    __agon_circle
    pop     ix
    pop     bc
    pop     af
    pop     af
    pop     af
    pop     af
    push    bc
    ret
