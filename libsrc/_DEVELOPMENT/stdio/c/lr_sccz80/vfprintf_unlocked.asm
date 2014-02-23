
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

XLIB vfprintf_unlocked

LIB asm_vfprintf_unlocked

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
