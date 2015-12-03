
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfprintf_unlocked

EXTERN asm_vfprintf_unlocked

_vfprintf_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_vfprintf_unlocked
