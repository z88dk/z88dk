
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vfprintf_unlocked_callee

EXTERN asm_vfprintf_unlocked

vfprintf_unlocked_callee:

   pop hl
   pop bc
   pop de
   pop af

   push ix
   push af
   pop ix
   ex (sp),hl
   push hl

   call asm_vfprintf_unlocked
   pop ix
   ret
