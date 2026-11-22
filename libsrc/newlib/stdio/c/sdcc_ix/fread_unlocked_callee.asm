
; size_t fread_unlocked_callee(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fread_unlocked_callee, l0_fread_unlocked_callee

EXTERN asm_fread_unlocked

_fread_unlocked_callee:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   push af

l0_fread_unlocked_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_fread_unlocked
   
   pop ix
   ret
