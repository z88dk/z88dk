
; int vscanf_unlocked(const char *format, void *arg)

XLIB vscanf_unlocked

LIB asm_vscanf_unlocked

vscanf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_vscanf_unlocked
