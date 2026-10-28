
; int fseek_unlocked(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC fseek_unlocked_callee

EXTERN asm_fseek_unlocked

fseek_unlocked_callee:

   pop hl
   pop bc
   pop de
   pop af
   ex (sp),hl

   push ix
   ld ix,hl

   push de
   push af
   pop de
   pop hl

   call asm_fseek_unlocked
   pop ix
   ret
