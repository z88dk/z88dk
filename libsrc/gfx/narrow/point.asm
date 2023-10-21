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

        pop     bc                      ; ret addr
        pop     hl                      ; y
        pop     de
        push    de
        push    hl
        ld      h, e                    ; x
        push    bc                      ; ret addr
        jp      asm_point

