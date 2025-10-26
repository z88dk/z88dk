;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: plot_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  plot(int x, int y)


        SECTION code_graphics

        PUBLIC  plot_callee
        PUBLIC  _plot_callee

        EXTERN  plot

plot_callee:
_plot_callee:
        pop     af                      ; ret addr
        pop     bc
        pop     de
        push    af                      ; ret addr
        push    de
        push    bc

        call    plot
        pop     bc
        pop     bc
        ret
