; int zx_setint(char *variable, int value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setint
PUBLIC _zx_setint

EXTERN asm_zx_setint

.zx_setint
._zx_setint

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_zx_setint
