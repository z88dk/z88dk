
; int vfprintf(FILE *stream, const char *format, void *arg)

XLIB vfprintf

LIB asm_vfprintf

vfprintf:
   
   pop af
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push af

   jp asm_vfprintf
