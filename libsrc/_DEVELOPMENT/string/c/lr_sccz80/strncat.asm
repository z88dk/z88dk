
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

XLIB strncat

LIB asm_strncat

strncat:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncat
