
; int fputs_unlocked_callee(const char *s, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fputs_unlocked_callee, l0_fputs_unlocked_callee

EXTERN asm_fputs_unlocked

_fputs_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af

l0_fputs_unlocked_callee:

   push bc
   ex (sp),ix
   
   call asm_fputs_unlocked
   
   pop ix
   ret
