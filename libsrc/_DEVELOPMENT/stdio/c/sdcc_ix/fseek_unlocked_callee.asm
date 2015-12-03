
; int fseek_unlocked_callee(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC _fseek_unlocked_callee, l0_fseek_unlocked_callee

EXTERN asm_fseek_unlocked

_fseek_unlocked_callee:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   push af

l0_fseek_unlocked_callee:

   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_fseek_unlocked
   
   pop ix
   ret
