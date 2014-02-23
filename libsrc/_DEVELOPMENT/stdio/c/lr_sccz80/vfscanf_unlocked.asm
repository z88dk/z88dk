
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

XLIB vfscanf_unlocked

LIB asm_vfscanf_unlocked

vfscanf_unlocked:

   pop af
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push af
   
   jp asm_vfscanf_unlocked
