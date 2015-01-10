
; BSD
; void bzero(void *mem, int bytes)

SECTION code_string

PUBLIC bzero_callee

bzero_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_bzero.asm"
