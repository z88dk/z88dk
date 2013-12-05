; int setcursorpos(x,y)
; CALLER linkage for function pointers
;
;       $Id: setcursorpos.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
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
