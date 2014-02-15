
; void *memmove(void *s1, const void *s2, size_t n)

XLIB memmove

LIB asm_memmove

memmove:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_memmove
