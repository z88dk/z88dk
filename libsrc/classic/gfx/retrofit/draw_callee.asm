;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)
;
;
;	$Id: draw_callee.asm $
;

        SECTION smc_clib

        PUBLIC  draw_callee
        PUBLIC  _draw_callee

        EXTERN  draw

draw_callee:
_draw_callee:
        ld      hl, retaddr
        ex      (sp), hl
        ld      (retaddr0+1), hl
        ld      hl, draw
        jp      (hl)

retaddr:
        pop     bc
        pop     bc
        pop     bc
        pop     bc
retaddr0:
        ld      hl, 0
        jp      (hl)

