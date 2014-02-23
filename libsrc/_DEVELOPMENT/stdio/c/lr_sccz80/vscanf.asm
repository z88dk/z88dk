
; int vscanf(const char *format, void *arg)

XLIB vscanf

LIB asm_vscanf

vscanf:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_vscanf
