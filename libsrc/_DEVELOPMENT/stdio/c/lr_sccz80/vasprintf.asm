
; int vasprintf(char **ptr, const char *format, void *arg)

XLIB vasprintf

LIB asm_vasprintf

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
