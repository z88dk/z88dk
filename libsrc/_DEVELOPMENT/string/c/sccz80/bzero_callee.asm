
; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC bzero_callee

EXTERN asm_bzero

bzero_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_bzero
