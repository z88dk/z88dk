
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fread_unlocked_callee

EXTERN asm_fread_unlocked

fread_unlocked_callee:

   pop hl
   pop de
   pop bc
   pop af
   ex (sp),hl

   push ix
   push de
   pop ix
   push bc
   push hl
   pop de
   pop hl
   push af
   pop bc

   call asm_fread_unlocked
   pop ix
   ret
