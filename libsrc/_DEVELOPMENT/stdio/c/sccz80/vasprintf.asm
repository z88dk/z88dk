
; int vasprintf(char **ptr, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vasprintf

EXTERN asm_vasprintf

vasprintf:

   pop af
   pop bc
   pop de
   exx
   pop de
   
   push de
   exx
   push de
   push bc
   push af
   
   jp asm_vasprintf
