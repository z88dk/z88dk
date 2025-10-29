;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: unplot_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  unplot(int x, int y)


        SECTION code_graphics

        PUBLIC  unplot_callee
        PUBLIC  _unplot_callee

        EXTERN  unplot

unplot_callee:
_unplot_callee:
        pop     af                      ; ret addr
        pop     bc
        pop     de
        push    af                      ; ret addr
        push    de
        push    bc

        call    unplot
        pop     bc
        pop     bc
        ret
