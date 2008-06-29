; int zx_getstr(char variable, char *value)
; CALLER linkage for function pointers

XLIB zx_getstr

LIB zx_getstr_callee
XREF ASMDISP_ZX_GETSTR_CALLEE

.zx_getstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp zx_getstr_callee + ASMDISP_ZX_GETSTR_CALLEE
