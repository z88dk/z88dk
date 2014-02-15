
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

XLIB strtok_r

LIB asm_strtok_r

strtok_r:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strtok_r
