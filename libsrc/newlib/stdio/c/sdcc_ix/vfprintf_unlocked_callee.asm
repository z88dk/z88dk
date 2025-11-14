
; int vfprintf_unlocked_callee(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfprintf_unlocked_callee, l0_vfprintf_unlocked_callee

EXTERN asm_vfprintf_unlocked

_vfprintf_unlocked_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_vfprintf_unlocked_callee:

   push hl
   ex (sp),ix
      
   call asm_vfprintf_unlocked
   
   pop ix
   ret
