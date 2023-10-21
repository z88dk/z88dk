; ----- int  point(int x, int y)
;Result is true/false


        SECTION code_graphics

        PUBLIC  point
        PUBLIC  _point
        PUBLIC  ___point

        EXTERN  asm_point

point:
_point:
___point:
        pop     bc
        pop     de                      ; y
        pop     hl                      ; x
        push    hl
        push    de
        push    bc
        jp      asm_point
