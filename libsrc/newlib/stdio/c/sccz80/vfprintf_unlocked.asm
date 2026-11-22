
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vfprintf_unlocked

EXTERN asm_vfprintf_unlocked

vfprintf_unlocked:

   pop af
   pop bc
   pop de
   pop ix
   
   push hl
   push de
   push bc
   push af
   
   jp asm_vfprintf_unlocked
