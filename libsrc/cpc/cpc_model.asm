;
; int cpc_model();
; 
; Results:
;    0 - 464
;    1 - 664
;    2 - 6128


; $Id: cpc_model.asm,v 1.1 2008-05-09 10:38:32 stefano Exp $


        XDEF cpc_model

.cpc_model
        ld      a,($BD65)
        ld      hl,0
        cp      158
        ret     z
        inc     hl
        cp      200
        ret     z
        inc     hl
        ret
