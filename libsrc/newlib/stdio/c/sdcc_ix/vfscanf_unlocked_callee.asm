
; int vfscanf_unlocked_callee(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfscanf_unlocked_callee, l0_vfscanf_unlocked_callee

EXTERN asm_vfscanf_unlocked

_vfscanf_unlocked_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_vfscanf_unlocked_callee:

   push hl
   ex (sp),ix
   
   call asm_vfscanf_unlocked
   
   pop ix
   ret
