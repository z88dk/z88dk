
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fwrite_unlocked_callee

EXTERN asm_fwrite_unlocked

fwrite_unlocked_callee:

   pop hl
   pop af
   pop de
   pop bc
   ex (sp),hl

   push ix
   push af
   pop ix

   call asm_fwrite_unlocked
   pop ix
   ret
