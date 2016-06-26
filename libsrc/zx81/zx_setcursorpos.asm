; int zx_setcursorpos(char variable, char *value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setcursorpos
PUBLIC _zx_setcursorpos

EXTERN zx_setcursorpos_callee
EXTERN ASMDISP_ZX_SETCURSORPOS_CALLEE

zx_setcursorpos:
_zx_setcursorpos:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp zx_setcursorpos_callee + ASMDISP_ZX_SETCURSORPOS_CALLEE
