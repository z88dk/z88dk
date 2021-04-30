; int zx_getstr(char variable, char *value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_getstr
PUBLIC _zx_getstr

EXTERN asm_zx_getstr

.zx_getstr
._zx_getstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_zx_getstr
