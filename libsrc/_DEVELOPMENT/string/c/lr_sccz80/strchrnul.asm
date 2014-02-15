
; char *strchrnul(const char *s, int c)

XLIB strchrnul

LIB asm_strchrnul

strchrnul:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strchrnul
