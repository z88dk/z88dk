; int zx_setcursorpos(char variable, char *value)
; CALLER linkage for function pointers

XLIB zx_setcursorpos

LIB zx_setcursorpos_callee
XREF ASMDISP_ZX_SETCURSORPOS_CALLEE

zx_setcursorpos:

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp zx_setcursorpos_callee + ASMDISP_ZX_SETCURSORPOS_CALLEE
