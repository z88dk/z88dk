;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ xorclga(int x, int y, int x2, int y2)
;
;
;	$Id: xorclga_callee.asm $
;

        SECTION smc_clib

        PUBLIC  xorclga_callee
        PUBLIC  _xorclga_callee

        EXTERN  xorclga

xorclga_callee:
_xorclga_callee:
        ld      hl, retaddr
        ex      (sp), hl
        ld      (retaddr0+1), hl
        ld      hl, xorclga
        jp      (hl)

retaddr:
        pop     bc
        pop     bc
        pop     bc
        pop     bc
retaddr0:
        ld      hl, 0
        jp      (hl)

