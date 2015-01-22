
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_stdio

PUBLIC _fwrite_unlocked

_fwrite_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push bc
   push hl
   push af
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_fwrite_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fwrite_unlocked.asm"
