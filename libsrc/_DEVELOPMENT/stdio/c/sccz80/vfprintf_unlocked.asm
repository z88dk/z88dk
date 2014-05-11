
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

PUBLIC vfprintf_unlocked

EXTERN asm_vfprintf_unlocked

vfprintf_unlocked:

   pop af
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push af
   
   jp asm_vfprintf_unlocked
