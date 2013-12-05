; int screen(x,y)
; CALLER linkage for function pointers
;
;       $Id: screen.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
;


XLIB screen

LIB screen_callee
XREF ASMDISP_screen_CALLEE

screen:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp screen_callee + ASMDISP_screen_CALLEE
