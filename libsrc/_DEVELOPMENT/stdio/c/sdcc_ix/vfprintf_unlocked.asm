
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_stdio

PUBLIC _vfprintf_unlocked

_vfprintf_unlocked:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push bc
   push af
   
   push bc
   exx
   
   ex (sp),ix
      
   call asm_vfprintf_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vfprintf_unlocked.asm"
