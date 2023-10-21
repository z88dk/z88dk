; CALLER LINKAGE FOR FUNCTION POINTERS

        SECTION code_clib
        PUBLIC  cplot
        PUBLIC  _cplot
        PUBLIC  ___cplot
        EXTERN  asm_cplot

cplot:
_cplot:
___cplot:

        pop     af
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        push    af


        jp      asm_cplot
