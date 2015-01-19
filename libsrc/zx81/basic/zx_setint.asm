; int zx_setint(char *variable, int value)
; CALLER linkage for function pointers

PUBLIC zx_setint

EXTERN zx_setint_callee
EXTERN ASMDISP_ZX_SETINT_CALLEE

.zx_setint

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp zx_setint_callee + ASMDISP_ZX_SETINT_CALLEE

