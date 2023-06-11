SECTION code_clib

PUBLIC uncircle_callee
PUBLIC _uncircle_callee
PUBLIC uncircle
PUBLIC _uncircle


EXTERN __agon_circle
EXTERN __agon_putc
EXTERN __agon_putword
EXTERN __agon_bgcol


; extern void __LIB__ uncircle(int x, int y, int radius, int skip) __smallc
uncircle:
_uncircle:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_circle
    pop     ix
    ret

; extern void __LIB__ uncircle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
uncircle_callee:
_uncircle_callee:
    push    ix
    ld      ix,4
    add     ix,sp
    ld      a,(__agon_bgcol)
    call    __agon_circle
    pop     ix
    pop     bc
    pop     af
    pop     af
    pop     af
    pop     af
    push    bc
    ret
