
; int vfscanf(FILE *stream, const char *format, void *arg)

XLIB vfscanf

LIB asm_vfscanf

vfscanf:

   pop af
   pop bc
   pop de
   pop ix

   push ix
   push de
   push bc
   push af
   
   jp asm_vfscanf
