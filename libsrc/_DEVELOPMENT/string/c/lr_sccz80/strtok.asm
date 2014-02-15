
; char *strtok(char * restrict s1, const char * restrict s2)

XLIB strtok

LIB asm_strtok

strtok:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strtok
