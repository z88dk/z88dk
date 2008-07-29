; int zx_setint(char *variable, int value)
; CALLER linkage for function pointers

XLIB zx_setint

LIB zx_setint_callee
XREF ASMDISP_ZX_SETINT_CALLEE

.zx_setint

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp zx_setint_callee + ASMDISP_ZX_SETINT_CALLEE

