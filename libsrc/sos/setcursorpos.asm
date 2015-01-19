; int setcursorpos(x,y)
; CALLER linkage for function pointers
;
;       $Id: setcursorpos.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC setcursorpos

EXTERN setcursorpos_callee
EXTERN ASMDISP_SETCURSORPOS_CALLEE

setcursorpos:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp setcursorpos_callee + ASMDISP_SETCURSORPOS_CALLEE
