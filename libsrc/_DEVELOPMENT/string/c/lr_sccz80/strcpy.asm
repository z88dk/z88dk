
; char *strcpy(char * restrict s1, const char * restrict s2)

XLIB strcpy

LIB asm_strcpy

strcpy:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcpy
