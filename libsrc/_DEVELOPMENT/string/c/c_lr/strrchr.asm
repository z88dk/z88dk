
XLIB strrchr

LIB asm_strrchr

strrchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strrchr
