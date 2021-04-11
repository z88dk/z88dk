; int setcursorpos(x,y)
; CALLER linkage for function pointers
;
;       $Id: setcursorpos.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

SECTION   code_clib
PUBLIC setcursorpos
PUBLIC _setcursorpos

EXTERN asm_setcursorpos

setcursorpos:
_setcursorpos:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_setcursorpos
