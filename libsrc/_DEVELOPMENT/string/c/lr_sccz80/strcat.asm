
; char *strcat(char * restrict s1, const char * restrict s2)

XLIB strcat

LIB asm_strcat

strcat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcat
