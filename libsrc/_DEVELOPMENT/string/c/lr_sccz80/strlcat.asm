
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

XLIB strlcat

LIB asm_strlcat

strlcat:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strlcat
