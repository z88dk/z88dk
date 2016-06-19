; int screen(x,y)
; CALLER linkage for function pointers
;
;       $Id: screen.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;


        SECTION   code_clib
PUBLIC screen
PUBLIC _screen

EXTERN screen_callee
EXTERN ASMDISP_screen_CALLEE

screen:
_screen:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp screen_callee + ASMDISP_screen_CALLEE
