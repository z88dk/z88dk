
XLIB strncasecmp

LIB asm_strncasecmp

strncasecmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncasecmp
