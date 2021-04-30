; int zx_setcursorpos(char variable, char *value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setcursorpos
PUBLIC _zx_setcursorpos

EXTERN asm_zx_setcursorpos

zx_setcursorpos:
_zx_setcursorpos:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_zx_setcursorpos
