; int setcursorpos(x,y)
; CALLER linkage for function pointers
;
;       $Id: setcursorpos.asm,v 1.1 2013-12-03 13:42:32 stefano Exp $
;


XLIB setcursorpos

LIB setcursorpos_callee
XREF ASMDISP_SETCURSORPOS_CALLEE

setcursorpos:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp setcursorpos_callee + ASMDISP_SETCURSORPOS_CALLEE
