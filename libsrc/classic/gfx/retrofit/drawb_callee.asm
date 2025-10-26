;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ drawb(int x, int y, int x2, int y2)
;
;
;	$Id: drawb_callee.asm $
;

        SECTION smc_clib

        PUBLIC  drawb_callee
        PUBLIC  _drawb_callee

        EXTERN  drawb

drawb_callee:
_drawb_callee:
        ld      hl, retaddr
        ex      (sp), hl
        ld      (retaddr0+1), hl
        ld      hl, drawb
        jp      (hl)

retaddr:
        pop     bc
        pop     bc
        pop     bc
        pop     bc
retaddr0:
        ld      hl, 0
        jp      (hl)

