; int zx_setstr(char variable, char *value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setstr
PUBLIC _zx_setstr

EXTERN zx_setstr_callee
EXTERN ASMDISP_ZX_SETSTR_CALLEE

.zx_setstr
._zx_setstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp zx_setstr_callee + ASMDISP_ZX_SETSTR_CALLEE
