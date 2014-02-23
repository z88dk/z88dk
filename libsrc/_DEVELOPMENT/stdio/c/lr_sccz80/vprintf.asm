
; int vprintf(const char *format, void *arg)

XLIB vprintf

LIB asm_vprintf

vprintf:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_vprintf
