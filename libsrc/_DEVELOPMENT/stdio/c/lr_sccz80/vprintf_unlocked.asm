
; int vprintf_unlocked(const char *format, void *arg)

XLIB vprintf_unlocked

LIB asm_vprintf_unlocked

vprintf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_vprintf_unlocked
