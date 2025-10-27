
; int vprintf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vprintf_unlocked

EXTERN asm_vprintf_unlocked

vprintf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_vprintf_unlocked
