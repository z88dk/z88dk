
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vsnprintf

EXTERN asm_vsnprintf

vsnprintf:

   pop af
   pop bc
   pop de
   exx
   pop bc
   pop de
   
   push de
   push bc
   exx
   push de
   push bc
   push af
   
   jp asm_vsnprintf
