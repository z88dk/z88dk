; int zx_setstr(char variable, char *value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_setstr
PUBLIC _zx_setstr

EXTERN asm_zx_setstr

.zx_setstr
._zx_setstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_zx_setstr
