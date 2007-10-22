; int zx_setstr(char variable, char *value)
; CALLER linkage for function pointers

XLIB zx_setstr

LIB zx_setstr_callee
XREF ASMDISP_ZX_SETSTR_CALLEE

.zx_setstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp zx_setstr_callee + ASMDISP_ZX_SETSTR_CALLEE
