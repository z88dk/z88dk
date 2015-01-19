; int zx_setcursorpos(char variable, char *value)
; CALLER linkage for function pointers

PUBLIC zx_setcursorpos

EXTERN zx_setcursorpos_callee
EXTERN ASMDISP_ZX_SETCURSORPOS_CALLEE

zx_setcursorpos:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp zx_setcursorpos_callee + ASMDISP_ZX_SETCURSORPOS_CALLEE
