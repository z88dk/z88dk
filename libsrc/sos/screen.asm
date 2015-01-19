; int screen(x,y)
; CALLER linkage for function pointers
;
;       $Id: screen.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC screen

EXTERN screen_callee
EXTERN ASMDISP_screen_CALLEE

screen:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp screen_callee + ASMDISP_screen_CALLEE
