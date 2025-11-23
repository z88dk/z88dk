;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: xordrawr_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawr(int x2, int y2)


        SECTION code_graphics

        PUBLIC  xordrawr_callee
        PUBLIC  _xordrawr_callee

        EXTERN  xordrawr

xordrawr_callee:
_xordrawr_callee:
        pop     af                      ; ret addr
        pop     bc
        pop     de
        push    af                      ; ret addr
        push    de
        push    bc

        call    xordrawr
        pop     bc
        pop     bc
        ret
